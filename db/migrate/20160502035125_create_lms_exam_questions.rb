class CreateLmsExamQuestions < ActiveRecord::Migration
  def change
    create_table :lms_exam_questions do |t|
      t.text :question_text
      t.integer :question_type
      t.timestamps null: false
    end
  end
end
