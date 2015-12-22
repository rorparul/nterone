class RemoveCourseAttributes < ActiveRecord::Migration
  def change
    remove_column :courses, :url
    remove_column :courses, :price
    remove_column :courses, :time_unit_quantity
    remove_column :courses, :time_unit
    remove_column :courses, :availabilities
  end
end
