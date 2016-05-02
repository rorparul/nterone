class CreateExamAttemptAnswers < ActiveRecord::Migration
  def change
    create_table :exam_attempt_answers do |t|
      t.references :exam_attempt, index: true, foreign_key: true
      t.references :exam_question, index: true, foreign_key: true
      t.references :exam_answer, index: true, foreign_key: true
      t.text :answer_text
    end
  end
end
