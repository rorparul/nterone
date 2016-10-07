class ChangeCourseRefToCompRefOnLabRental < ActiveRecord::Migration
  def change
    remove_column :lab_rentals, :course_id
    add_column    :lab_rentals, :company_id, :integer
  end
end
