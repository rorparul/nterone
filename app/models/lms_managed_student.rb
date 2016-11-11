class LmsManagedStudent < ActiveRecord::Base
	belongs_to :user
	belongs_to :manager, class_name: 'User'
end
