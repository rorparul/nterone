# == Schema Information
#
# Table name: opportunities
#
#  id                 :integer          not null, primary key
#  employee_id        :integer
#  customer_id        :integer
#  account_id         :integer
#  title              :string
#  stage              :integer
#  amount             :decimal(8, 2)    default(0.0)
#  kind               :string
#  reason_for_loss    :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  waiting            :boolean          default(FALSE)
#  payment_kind       :string
#  billing_street     :string
#  billing_city       :string
#  billing_state      :string
#  billing_zip_code   :string
#  partner_id         :integer
#  date_closed        :date
#  course_id          :integer
#  event_id           :integer
#  email_optional     :string
#  notes              :text
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#  video_on_demand_id :integer
#
# Indexes
#
#  index_opportunities_on_origin_region  (origin_region)
#

require 'test_helper'

class OpportunityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
