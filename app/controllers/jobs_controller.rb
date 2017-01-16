class JobsController < ApplicationController
	include ActionView::Helpers::TextHelper 
	before_action :require_login
	def index
		@user=User.find(params[:user_id])
		@user.jobs.each do |j|
			if j.next_run_at<Time.zone.now
				next_run_at=when_next(j.next_run_at,j.frequency)
				j.update(next_run_at:next_run_at)
			end	
		end
		# global var for @jobs, e.g 'status DESC'
		if $job_sort_by.nil?
			@jobs=@user.jobs
		else
			@jobs=@user.jobs.order($job_sort_by) 
		end
	end
	
	def new
		@job=Job.new
		@user=User.find_by(id:params[:user_id])
	end

	def create
        @user=User.find(params[:user_id])
		# add +0800 implicit timezone to match local timezone
		first_run_at = DateTime.strptime(params[:job][:first_run_at]+" +0800",'%m/%d/%Y %l:%M %p %z') if not params[:job][:first_run_at].empty?	
		# add delete blank to job title
		@job=Job.create(title:params[:job][:title].delete(" "),first_run_at:first_run_at,alert_email:params[:job][:alert_email],status:"New",frequency:params[:job][:frequency],jobtype_id:params[:job][:jobtype_id],user_id:params[:user_id])
		if @job.valid?
			add_crontab(first_run_at,@job.id)
			next_run_at=when_next(first_run_at,params[:job][:frequency])
			@job.update(next_run_at:next_run_at)
		 	@job.save
            params[:param_value].each_pair do |k,v|
                @parameter=Parameter.new(param_name:k,param_value:v,job_id:@job.id)
                @parameter.save
            end
			render js: "window.location='#{user_jobs_path(@user)}'"	
		else
		 	@error_msg=simple_format(@job.errors.messages.to_s)
			render 'shared/error' 
		end
	end

    def edit
		 @job=Job.find(params[:id])
		 @user=User.find(params[:user_id])
    end

	def update
		 @user=User.find(params[:user_id])
		 @job=Job.find(params[:id])
		 first_run_at = DateTime.strptime(params[:job][:first_run_at]+" +0800",'%m/%d/%Y %l:%M %p %z') if not params[:job][:first_run_at].empty? 
	 	 @job.update(title:params[:job][:title].delete(" "),alert_email:params[:job][:alert_email],first_run_at:first_run_at,status:"Modified",frequency:params[:job][:frequency],jobtype_id:params[:job][:jobtype_id])
		 if @job.valid?			
		 	next_run_at=when_next(first_run_at,params[:job][:frequency])
			@job.update(next_run_at:next_run_at)
            @job.parameters.each{|p| p.destroy}
            params[:param_value].each_pair do |k,v|
                @parameter=Parameter.new(param_name:k,param_value:v,job_id:@job.id)
                @parameter.save
            end
		 	rm_crontab(@job.id)
		 	add_crontab(first_run_at,@job.id) 
		 	render js: "window.location='#{user_jobs_path(@user)}'" 
		 else
			@error_msg=simple_format(@job.errors.messages.to_s)
			render 'shared/error',formats:'js' 
		 end
	end

	def destroy
		 @job=Job.find(params[:id])
		 rm_crontab(@job.id)
		 @job.destroy
		 redirect_to user_jobs_path
	end
	
	def run
		@user=User.find(params[:user_id])
		@job=Job.find(params[:id])
		if @job.status!="Running"
            system "RAILS_ENV=#{Rails.env} rake webcron:excutejob[#{@job.id}] &"
			render js: "window.location='#{user_jobs_path(@user)}'"	
		else
			@error_msg=simple_format("Job is running!")
			render 'shared/error' 
		end
	end

	def abort
		@user=User.find(params[:user_id])
		@job=Job.find(params[:id])
		if @job.status=="Running"
			system "pkill -P "+@job.pid.to_s
			# kill single process instead of parent pid
			# system "kill "+@job.pid.to_s
			render js: "window.location='#{user_jobs_path(@user)}'"	
		else
			@error_msg=simple_format("Job isn't running!")
			render 'shared/error' 
		end
	end
	
	def refresh
		respond_to do |format|
			msg=Job.select("id,status,progress,last_end_at") 
			format.json  { render :json => msg } # don't do msg.to_json
		end	
	end
		
	def sort
		@user=User.find(params[:user_id])
		# twice click reverse
		if $job_sort_by.nil? or $job_sort_by.index(params[:sort_by]).nil?
			$job_sort_by=params[:sort_by]+" DESC"
				puts $job_sort_by
			@jobs=@user.jobs.order($job_sort_by)	
		else
			if ! $job_sort_by.index('DESC').nil?
				$job_sort_by=$job_sort_by.gsub('DESC','ASC')
			else	
				$job_sort_by=$job_sort_by.gsub('ASC','DESC')
			end
			@jobs=@user.jobs.order($job_sort_by)
		end
	end
		
private 
	def add_crontab(first_run_at,job_id)
        which_rake=%x[which rake].strip
        cmd_str="cd #{Rails.root.to_s} && #{which_rake} RAILS_ENV=#{Rails.env} webcron:excutejob[#{job_id}] >>/tmp/webcron.#{Rails.env}.log 2>&1"
        case params[:job][:frequency]
		    when "monthly"
		       	time_str=first_run_at.strftime("%M")+" "+first_run_at.strftime("%k")+" "+first_run_at.strftime("%-d")+" * *"
		    when "weekly"
		       	time_str=first_run_at.strftime("%M")+" "+first_run_at.strftime("%k")+" * * "+first_run_at.strftime("%u")
		    when "daily"
	   		    time_str=first_run_at.strftime("%M")+" "+first_run_at.strftime("%k")+" * * *"
	    end
		crontab_str="crontab -l | { cat; echo '"+time_str+" "+cmd_str+"';} | crontab -"
		system crontab_str
    end
	
	def rm_crontab(job_id)
		 crontab_str="crontab -l|sed '/#{Rails.env} webcron:excutejob\\[#{job_id}\\]/d'|crontab -"
		 system crontab_str 
	end
	
	def when_next(first_run_at,frequency)
		 next_run_at=first_run_at	
			case frequency
				when 'monthly'
					while Time.zone.now>next_run_at
						next_run_at=next_run_at+1.months
					end
				when 'weekly'
					while Time.zone.now>next_run_at
						next_run_at=next_run_at+1.weeks
					end
				when 'daily'
					while Time.zone.now>next_run_at
						next_run_at=next_run_at+1.days
					end
				when 'hourly'
					while Time.zone.now>next_run_at
						next_run_at=next_run_at+1.hours			
					end
			end
		return next_run_at
	end

   	def require_login
		# puts session[:user_id].class,params[:user_id].class
		# Fixnum, String
		if session[:user_id].to_s != params[:user_id].to_s
			redirect_to '/'
		end	
	end
end
