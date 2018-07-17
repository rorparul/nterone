class AddInstructorIdToEmployments < ActiveRecord::Migration
  def change
    add_column :employments, :instructor_id, :integer
  end
end
