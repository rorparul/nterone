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

require 'test_helper'

class LmsManagedStudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
