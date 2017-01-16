class HistorysController < ApplicationController

	def index
		@user=User.find(params[:user_id])
		@job=Job.find(params[:job_id])
	end	



















end
