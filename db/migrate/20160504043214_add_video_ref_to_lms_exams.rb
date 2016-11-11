class AddVideoRefToLmsExams < ActiveRecord::Migration
  def change
    add_reference :lms_exams, :video, index: true, foreign_key: true
  end
end
