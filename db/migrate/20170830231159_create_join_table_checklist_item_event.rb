class CreateJoinTableChecklistItemEvent < ActiveRecord::Migration
  def change
    create_join_table :checklist_items, :events do |t|
      t.index [:checklist_item_id, :event_id]
      # t.index [:event_id, :checklist_item_id]
    end
  end
end
