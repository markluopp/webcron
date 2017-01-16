class SessionController < ApplicationController
	include ActionView::Helpers::TextHelper 
	def login
		if session[:user_id]
			@user=User.find_by(id:session[:user_id])
			case session[:user_type]
				when 'admin'
					redirect_to users_path
				when 'common'
					redirect_to user_jobs_path(@user)
			end	
		end
	end

	def verify
		@user=User.find_by(username:params[:session][:username],passwd:params[:session][:passwd])
		if @user	
			session[:user_id]=@user.id
			session[:user_type]=@user.user_type
			case @user.user_type
				when 'admin'	
					render js: "window.location='#{users_path}'"
				when 'common'
					render js: "window.location='#{user_jobs_path(@user)}'"
			end
		else
			@error_msg=simple_format("Invalid Username&Password!")	
			render 'shared/error'	
		end
	end
end
