class AddPositionToLmsExamQuestions < ActiveRecord::Migration
  def change
    add_column :lms_exam_questions, :position, :integer
  end
end
