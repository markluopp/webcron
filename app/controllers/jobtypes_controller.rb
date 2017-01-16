class JobtypesController < ApplicationController
	include ActionView::Helpers::TextHelper # to use simple_format()	
	def index

	end
	
	def new
		@jobtype=Jobtype.new
	end

	def create
        @jobtype=Jobtype.new(jobtype_name:params[:jobtype][:jobtype_name],call_script:params[:jobtype][:call_script])
		if @jobtype.valid?
			@jobtype.save
            params[:param_name].each_pair do |k,v|
                @parameter_option=ParameterOption.new(param_name:v,param_help:params[:param_help][k],jobtype_id:@jobtype.id)
                @parameter_option.save
            end
			@verify_result=simple_format(verify_jobtype(@jobtype.call_script))
			render 'verify'
		else
			@error_msg=simple_format(@jobtype.errors.messages.to_s)
			render 'shared/error'
		end
	end

	def edit
		@jobtype=Jobtype.find(params[:id])
	end	

	def update
		@jobtype=Jobtype.find(params[:id])
		@jobtype.update(jobtype_name:params[:jobtype][:jobtype_name],call_script:params[:jobtype][:call_script])
		if @jobtype.valid?	
            @jobtype.parameter_options.each{|p| p.destroy}
            params[:param_name].each_pair do |k,v|
                @parameter_option=ParameterOption.new(param_name:v,param_help:params[:param_help][k],jobtype_id:@jobtype.id)
                @parameter_option.save
            end
			@verify_result=simple_format(verify_jobtype(@jobtype.call_script))
			render 'verify'	
		else
			@error_msg=simple_format(@jobtype.errors.messages.to_s)
			render 'shared/error'
		end
	end

	def destroy
		@jobtype=Jobtype.find(params[:id])
		@jobtype.destroy
		redirect_to jobtypes_path
	end	

	def verify_jobtype(call_script)
		# Rails.env=="production"
		sh_result=%x[#{call_script} 2>&1]
		return sh_result
	end

end
