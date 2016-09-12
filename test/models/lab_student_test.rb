# == Schema Information
#
# Table name: lab_students
#
#  id            :integer          not null, primary key
#  lab_rental_id :integer
#  name          :string
#  email         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class LabStudentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
