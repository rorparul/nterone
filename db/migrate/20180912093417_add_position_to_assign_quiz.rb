class AddPositionToAssignQuiz < ActiveRecord::Migration
  def change
    add_column :assign_quizzes, :position, :integer
  end
end
