class RenameTableToEmployments < ActiveRecord::Migration
  def change
    rename_table :employments, :resource_events
  end
end
