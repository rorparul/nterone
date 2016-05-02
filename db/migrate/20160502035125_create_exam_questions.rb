class CreateExamQuestions < ActiveRecord::Migration
  def change
    create_table :exam_questions do |t|
      t.references :exam, index: true, foreign_key: true
      t.text :question_text
      t.integer :type
      t.integer :position
    end
  end
end
