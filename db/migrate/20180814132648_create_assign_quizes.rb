class CreateAssignQuizes < ActiveRecord::Migration
  def change
    create_table :assign_quizes do |t|

      t.timestamps null: false
    end
  end
end
