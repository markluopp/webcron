class Jobmailer < ApplicationMailer
    default from: 'notifications@webcron.com'

    def log_email(history)
        @history=history
        @job=@history.job
        mail(to:@job.alert_email,subject: "[WebCron] #{@job.title} #{@job.status}")
    end

end
