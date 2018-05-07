# == Schema Information
#
# Table name: assigned_items
#
#  id             :integer          not null, primary key
#  assigner_id    :integer
#  student_id     :integer
#  item_id        :integer
#  item_type      :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_assigned_items_on_item_type_and_item_id  (item_type,item_id)
#  index_assigned_items_on_origin_region          (origin_region)
#

require 'test_helper'

class AssignedItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
