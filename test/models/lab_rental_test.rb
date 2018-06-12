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
#  confirmed         :boolean          default(FALSE)
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
#  twenty_four_hours :boolean          default(FALSE)
#  last_day          :date
#  level             :string
#  origin_region     :integer
#  active_regions    :text             default([]), is an Array
#  setup_by          :integer
#  tested_by         :integer
#  number_of_pods    :integer
#  plus_instructor   :boolean          default(FALSE)
#  price             :decimal(8, 2)    default(0.0)
#  po_number         :integer
#  entered_into_crm  :boolean          default(FALSE)
#  invoice_number    :string
#  payment_received  :boolean          default(FALSE)
#  poc               :string
#  terms             :string
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
