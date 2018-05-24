class AddColumnExcludeFromRevenueToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :exclude_from_revenue, :boolean, default: false
  end
end
