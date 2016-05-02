class CreateExamAnswers < ActiveRecord::Migration
  def change
    create_table :exam_answers do |t|
      t.text :answer_text
      t.references :exam_question, index: true, foreign_key: true
      t.integer :position
    end
  end
end
