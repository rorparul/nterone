class CreateLmsExamAnswers < ActiveRecord::Migration
  def change
    create_table :lms_exam_answers do |t|
      t.text :answer_text
      t.references :lms_exam_question, index: true, foreign_key: true
      t.integer :position
      t.timestamps null: false
    end
  end
end
