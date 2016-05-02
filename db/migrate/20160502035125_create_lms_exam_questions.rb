class CreateLmsExamQuestions < ActiveRecord::Migration
  def change
    create_table :lms_exam_questions do |t|
      t.text :question_text
      t.integer :type
      t.timestamps null: false
    end
  end
end
