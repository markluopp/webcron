class User < ActiveRecord::Base
	has_many :jobs, dependent: :destroy
	has_many :permissions, dependent: :destroy
	has_many :jobtypes, through: :permissions
	validates :username,:passwd, presence: true
end
