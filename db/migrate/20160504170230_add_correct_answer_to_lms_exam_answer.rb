class AddCorrectAnswerToLmsExamAnswer < ActiveRecord::Migration
  def change
    add_column :lms_exam_answers, :correct, :boolean, default: false
  end
end
