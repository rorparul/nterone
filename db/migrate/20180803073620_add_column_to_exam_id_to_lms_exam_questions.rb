class AddColumnToExamIdToLmsExamQuestions < ActiveRecord::Migration
  def change
    add_column :lms_exam_questions, :lms_exam_id, :integer
  end
end
