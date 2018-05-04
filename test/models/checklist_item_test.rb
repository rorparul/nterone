# == Schema Information
#
# Table name: checklist_items
#
#  id             :integer          not null, primary key
#  checklist_id   :integer
#  content        :text
#  completed_at   :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_checklist_items_on_checklist_id   (checklist_id)
#  index_checklist_items_on_origin_region  (origin_region)
#
# Foreign Keys
#
#  fk_rails_...  (checklist_id => checklists.id)
#

require 'test_helper'

class ChecklistItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
