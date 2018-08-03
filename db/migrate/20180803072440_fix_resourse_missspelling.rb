class FixResourseMissspelling < ActiveRecord::Migration
  def change
    rename_table :resourse_events, :resource_events
  end
end
