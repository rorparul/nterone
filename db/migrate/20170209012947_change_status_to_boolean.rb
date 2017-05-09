class ChangeStatusToBoolean < ActiveRecord::Migration
  def change
    remove_column :tasks, :status
    add_column :tasks, :complete, :boolean, default: false
  end
end
