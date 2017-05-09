class AddDefaultToPodCount < ActiveRecord::Migration
  def change
    change_column :lab_courses, :pods_individual, :integer, default: 0
    change_column :lab_courses, :pods_partner, :integer, default: 0
  end
end
