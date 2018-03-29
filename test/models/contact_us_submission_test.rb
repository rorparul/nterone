# == Schema Information
#
# Table name: contact_us_submissions
#
#  id             :integer          not null, primary key
#  name           :string
#  phone          :string
#  email          :string
#  inquiry        :string
#  feedback       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  recipient      :string
#  subject        :string
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  message        :text             default("")
#
# Indexes
#
#  index_contact_us_submissions_on_origin_region  (origin_region)
#

require 'test_helper'

class ContactUsSubmissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
