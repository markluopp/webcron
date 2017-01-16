class Job < ActiveRecord::Base
	belongs_to :user
	belongs_to :jobtype
	has_many :histories, dependent: :destroy
	has_many :parameters, dependent: :destroy
	validates :title, presence: true, uniqueness: true
	validates :first_run_at, presence: true
 	#validates :params, presence: true, format: {with: /\A((.)+=(.)+(\r\n)?)+\z/, message: "Invalid Parameter Format!"}
end
