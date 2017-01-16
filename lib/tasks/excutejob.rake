namespace :webcron do
    desc "excute webcron job"
    #rake webcron:excutejob[123]
    #suggest quoted: rake "webcron:excutejob[123]"
    task :excutejob,[:job_id] => :environment do |t,args|
        puts "[#{Time.now()}] start excute rake task, rake webcron:excutejob[#{args.job_id}]"

        Job.connection
        @job=Job.find(args.job_id)
        script_str=@job.jobtype.call_script
        
        @parameters=@job.parameters.order(:id)
        pm_str=''
        # quoted each parameter value and remove "\r\n" to keep in one line
        @parameters.each {|p| pm_str=pm_str+"'#{p.param_value.gsub("\r\n"," ")}' "}

        start_time=Time.zone.now()
        @job.update(status:"Running",progress:"0%")
        log_file="/tmp/#{Rails.env}.webcron.job.#{args.job_id}.log"

        puts "[#{Time.now()}] run cmd: #{script_str} #{pm_str}"
        puts "[#{Time.now()}] log file locate at: #{log_file}"

        pid=Process.spawn("#{script_str} #{pm_str}",[:err,:out]=>log_file)
        # spawn() method is similar to Kernel#system but it doesn’t wait for the command to finish 
        @history=History.create(job_id:args.job_id)
        @history.save
        
        puts "[#{Time.now()}] cmd pid: #{pid}"
       
        @job.update(pid:pid)
        avg_execution_time=History.average(:execution_time)
       
        # continue reading log file until process end
        loop do
            #@history.update(log:%x[cat /tmp/webcron.#{args.job_id}.log])
            @history.update(log:IO.read(log_file))
            if Process.waitpid(pid, Process::WNOHANG)
            # Process::WNOHANG means no blocking
            # return nil if child process(pid) is still running else return pid
                if $?.exitstatus != 0
                    puts "[#{Time.now()}] cmd failed with exitcode: #{$?.exitstatus}"
                    @job.update(status:'Failed',last_end_at:Time.zone.now) 
                    @history.update(execution_time:(Time.now()-start_time),log:IO.read(log_file))
                    Jobmailer.log_email(@history).deliver
                    exit
                else
                    break
                end
            end
            # update progress according to average execution time
            if avg_execution_time and avg_execution_time != 0
                percent=(((Time.zone.now()-start_time)/avg_execution_time)*100).round
                @job.update(progress:percent.to_s+'%')
            end
        end
        
        puts "[#{Time.now()}] cmd successed"
        @history.update(execution_time:(Time.now()-start_time),log:IO.read(log_file))
        @job.update(status:'Successed',progress:'100%',last_end_at:Time.zone.now) 
        
        Jobmailer.log_email(@history).deliver
    end  
end
