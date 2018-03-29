# == Schema Information
#
# Table name: checklists
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name           :string
#  active_regions :text             default([]), is an Array
#  origin_region  :integer
#
# Indexes
#
#  index_checklists_on_origin_region  (origin_region)
#

require 'test_helper'

class ChecklistTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
