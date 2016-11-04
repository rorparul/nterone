class AddCorrectAnswerToLmsExamQuestions < ActiveRecord::Migration
  def change
    add_column :lms_exam_questions, :correct_answer_id, :integer
  end
end
