class AddCourseToLabRental < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :course, :string
  end
end
