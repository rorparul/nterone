# == Schema Information
#
# Table name: checklist_items
#
#  id           :integer          not null, primary key
#  checklist_id :integer
#  content      :text
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_checklist_items_on_checklist_id  (checklist_id)
#
# Foreign Keys
#
#  fk_rails_3605ca8e4d  (checklist_id => checklists.id)
#

class ChecklistItem < ActiveRecord::Base
  belongs_to :checklist
end
