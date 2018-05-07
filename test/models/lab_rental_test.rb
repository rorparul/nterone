# == Schema Information
#
# Table name: lab_rentals
#
#  id                :integer          not null, primary key
#  first_day         :date
#  num_of_students   :integer          default(0)
#  start_time        :time
#  instructor        :string
#  instructor_email  :string
#  instructor_phone  :string
#  notes             :text
#  location          :string
#  confirmed         :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course            :string
#  user_id           :integer
#  company_id        :integer
#  canceled          :boolean
#  end_time          :time
#  lab_course_id     :integer
#  kind              :integer
#  time_zone         :string
#  twenty_four_hours :boolean
#  last_day          :date
#  level             :string
#  origin_region     :integer
#  active_regions    :text             default([]), is an Array
#
# Indexes
#
#  index_lab_rentals_on_lab_course_id  (lab_course_id)
#  index_lab_rentals_on_origin_region  (origin_region)
#
# Foreign Keys
#
#  fk_rails_...  (lab_course_id => lab_courses.id)
#

require 'test_helper'

class LabRentalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
