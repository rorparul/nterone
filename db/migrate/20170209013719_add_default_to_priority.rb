class AddDefaultToPriority < ActiveRecord::Migration
  def change
    change_column :tasks, :priority, :integer, default: 2
  end
end
