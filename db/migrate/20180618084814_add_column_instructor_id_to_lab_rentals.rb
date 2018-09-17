class AddColumnInstructorIdToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :instructor_id, :integer
  end
end
