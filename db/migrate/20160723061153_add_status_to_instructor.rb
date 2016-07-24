class AddStatusToInstructor < ActiveRecord::Migration
  def change
    add_column :instructors, :status, :integer, default: 0
  end
end
