class RemoveVideoidToAssignQuizzes < ActiveRecord::Migration
  def change
    remove_column :assign_quizzes, :video_id
    add_column :assign_quizzes, :video_module_id, :integer
  end
end
