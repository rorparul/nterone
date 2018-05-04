# == Schema Information
#
# Table name: sales_goals
#
#  id            :integer          not null, primary key
#  month         :date
#  amount        :integer
#  description   :text
#  origin_region :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class SalesGoalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
