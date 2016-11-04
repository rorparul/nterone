class RemoveQuestionTypeFromLmsExamQuestions < ActiveRecord::Migration
  def change
    remove_column :lms_exam_questions, :question_type, :integer
  end
end
