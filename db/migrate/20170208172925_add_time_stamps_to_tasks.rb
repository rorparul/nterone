class AddTimeStampsToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :created_at, :datetime, null: false
    add_column :tasks, :updated_at, :datetime, null: false
  end
end
