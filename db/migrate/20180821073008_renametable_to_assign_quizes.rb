class RenametableToAssignQuizes < ActiveRecord::Migration
  def change
    rename_table :assign_quizes, :assign_quizzes
  end
end
