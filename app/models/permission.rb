class Permission < ActiveRecord::Base
	belongs_to :jobtype
	belongs_to :user
end
