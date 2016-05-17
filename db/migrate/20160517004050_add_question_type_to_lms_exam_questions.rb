class AddQuestionTypeToLmsExamQuestions < ActiveRecord::Migration
  def change
    add_column :lms_exam_questions, :question_type, :integer, default: 0
  end
end
