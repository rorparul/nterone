class RemoveCorrectAnswerFromLmsExamQuestions < ActiveRecord::Migration
  def change
    remove_column :lms_exam_questions, :correct_answer_id
  end
end
