class CreateLmsExamAttemptAnswers < ActiveRecord::Migration
  def change
    create_table :lms_exam_attempt_answers do |t|
      t.references :lms_exam_attempt, index: true, foreign_key: true
      t.references :lms_exam_question, index: true, foreign_key: true
      t.references :lms_exam_answer, index: true, foreign_key: true
      t.text :answer_text
      t.timestamps null: false
    end
  end
end
