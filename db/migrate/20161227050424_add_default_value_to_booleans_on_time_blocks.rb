class AddDefaultValueToBooleansOnTimeBlocks < ActiveRecord::Migration
  def change
    change_column :lab_course_time_blocks, :level_individual, :boolean, default: false
    change_column :lab_course_time_blocks, :level_partner, :boolean, default: false
  end
end
