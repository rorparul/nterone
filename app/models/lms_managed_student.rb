# == Schema Information
#
# Table name: lms_managed_students
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  manager_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LmsManagedStudent < ActiveRecord::Base
	belongs_to :user
	belongs_to :manager, class_name: 'User'
end
