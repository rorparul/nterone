# == Schema Information
#
# Table name: lms_managed_students
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  manager_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class LmsManagedStudent < ActiveRecord::Base
  include Regions

	belongs_to :user
	belongs_to :manager, class_name: 'User'
end
