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
# Indexes
#
#  index_lms_managed_students_on_origin_region  (origin_region)
#

class LmsManagedStudent < ActiveRecord::Base
  include Regions

	belongs_to :user
	belongs_to :manager, class_name: 'User'

  validates :user_id, uniqueness: { scope: :manager_id }
end
