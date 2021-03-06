# == Schema Information
#
# Table name: checklist_items_events
#
#  checklist_item_id :integer          not null
#  event_id          :integer          not null
#  id                :integer          not null, primary key
#  updated_at        :datetime
#  updated_by        :integer
#
# Indexes
#
#  index_checklist_items_events_on_checklist_item_id_and_event_id  (checklist_item_id,event_id)
#

class ChecklistItemsEvents < ActiveRecord::Base

  belongs_to :checklist_item
  belongs_to :event

  belongs_to :user, foreign_key: "updated_by" 

end
