class AddForeignKeyToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :platform_id, :integer
  end
end
