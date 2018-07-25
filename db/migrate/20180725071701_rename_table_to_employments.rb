class RenameTableToEmployments < ActiveRecord::Migration
  def change
    rename_table :employments, :resourse_events
  end
end
