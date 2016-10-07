class AddFormTypeToCourse < ActiveRecord::Migration
  def change
    add_column :lab_courses, :company_id, :integer
  end
end
