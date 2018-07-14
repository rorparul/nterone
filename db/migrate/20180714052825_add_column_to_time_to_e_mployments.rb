class AddColumnToTimeToEMployments < ActiveRecord::Migration
  def change
    add_column :employments, :start_time, :time
    add_column :employments, :end_time, :time
  end
end
