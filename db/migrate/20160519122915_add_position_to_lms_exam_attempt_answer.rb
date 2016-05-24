class AddPositionToLmsExamAttemptAnswer < ActiveRecord::Migration
  def change
    add_column :lms_exam_attempt_answers, :position, :integer
  end
end
