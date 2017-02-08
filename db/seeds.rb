Job.create!([
  {title: "test_shell_job", alert_email: "yourmail@some.com", status: "Successed", progress: "100%", last_end_at: "2017-01-16 23:40:29", next_run_at: "2017-02-02 21:00:00", first_run_at: "2017-01-02 21:00:00", frequency: "monthly", user_id: 2, jobtype_id: 1},
  {title: "test_ruby_job", alert_email: "yourmail@some.com", status: "Failed", progress: "79%", last_end_at: "2017-01-16 23:21:25", next_run_at: "2017-01-23 23:10:00", first_run_at: "2017-01-02 23:10:00", frequency: "weekly", user_id: 2, jobtype_id: 2}
])
Jobtype.create!([
  {jobtype_name: "shell script", call_script: "bash ./sample/test.sh"},
  {jobtype_name: "ruby script", call_script: "ruby ./sample/test.rb"}
])
Parameter.create!([
  {param_name: "sex", param_value: "male", job_id: 1},
  {param_name: "echostr", param_value: "shell is awesome", job_id: 1},
  {param_name: "echoDetail", param_value: "you have\r\na lot of information\r\nin detail", job_id: 1},
  {param_name: "sex", param_value: "female", job_id: 2},
  {param_name: "echostr", param_value: "ruby is magic", job_id: 2},
])
ParameterOption.create!([
  {param_name: "sex", param_help: "male|female", jobtype_id: 1},
  {param_name: "echostr", param_help: "this is a sample text field", jobtype_id: 1},
  {param_name: "echoDetail", param_help: "<textarea> detail with multiple rows", jobtype_id: 1},
  {param_name: "sex", param_help: "male|female", jobtype_id: 2},
  {param_name: "echostr", param_help: "this is a sample text field", jobtype_id: 2}
])
Permission.create!([
  {user_id: 2, jobtype_id: 1},
  {user_id: 2, jobtype_id: 2}
])
User.create!([
  {username: "admin", passwd: "1234", user_type: "admin"},
  {username: "test", passwd: "1234", user_type: "common"}
])
