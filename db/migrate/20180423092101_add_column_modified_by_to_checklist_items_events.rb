class AddColumnModifiedByToChecklistItemsEvents < ActiveRecord::Migration
  def change
    add_column :checklist_items_events, :id, :primary_key
    add_column :checklist_items_events, :updated_at, :datetime
    add_column :checklist_items_events, :updated_by, :integer
  end
end
