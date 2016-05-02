class CreateLmsExamQuestionJoin < ActiveRecord::Migration
  def change
    create_table :lms_exam_question_joins do |t|
    	t.references :lms_exam, index: true, foreign_key: true
      t.references :lms_exam_question, index: true, foreign_key: true
      t.integer :position
      t.boolean :active
      t.timestamps null: false
    end
  end
end
