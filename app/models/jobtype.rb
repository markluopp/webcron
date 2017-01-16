class Jobtype < ActiveRecord::Base
	has_many :jobs, dependent: :destroy
	has_many :permissions, dependent: :destroy
	has_many :users, through: :permissions
	has_many :parameter_options, dependent: :destroy
	validates :jobtype_name, presence: true, uniqueness: true
	validates :call_script, presence: true
	#validates :params_std, presence: true, format: {with: /\A((.)+=(.)+(\r\n)?)+\z/, message: "Parameter Input Standard should follow this format: param_name=value_format, each parameter delimited by newline."}
end
