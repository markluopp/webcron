class UsersController < ApplicationController
	include ActionView::Helpers::TextHelper
	before_action :require_login
	skip_before_action :require_login, only: [:logout]
	def index
		@users=User.all
	end

	def logout
		session.destroy
		redirect_to '/'
	end

	def new
		@user=User.new
	end

	def create
		@user=User.new(username:params[:user][:username],passwd:params[:user][:passwd],user_type:params[:user][:user_type])
		if @user.valid?
			if not params[:jobtype_id].nil?
				@user.save
				params[:jobtype_id].each do |t|
					@permission=Permission.new(user_id:@user.id,jobtype_id:t)
					@permission.save
				end
				render js: "window.location='#{users_path}'"
			else
				@error_msg=simple_format('Please Select At Least One Jobtype!')
				render 'shared/error'		
			end
		else
			@error_msg=simple_format(@user.errors.messages.to_s)
			render 'shared/error'
		end
	end

	def edit
		@user=User.find(params[:id])
	end

	def update
		@user=User.find(params[:id])
		@user.update(username:params[:user][:username],passwd:params[:user][:passwd],user_type:params[:user][:user_type])
		if @user.valid?
			if not params[:jobtype_id].nil?
				@user.permissions.each{ |p| p.destroy}
				params[:jobtype_id].each do |t|
					@permission=Permission.new(user_id:@user.id,jobtype_id:t)
					@permission.save
				end
				render js: "window.location='#{users_path}'"
			else
				@error_msg=simple_format('Please Select At Least One Jobtype!')
				render 'shared/error'		
			end
		else
			@error_msg=simple_format(@user.errors.messages.to_s)
			render 'shared/error'
		end
	end

	def destroy
		@user=User.find(params[:id])
		@user.destroy
		redirect_to action: :index
	end

private
	def require_login
		if session[:user_type]!='admin'	
			redirect_to '/'
		end
	end
end
