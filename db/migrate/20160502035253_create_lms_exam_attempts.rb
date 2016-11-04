class CreateLmsExamAttempts < ActiveRecord::Migration
  def change
    create_table :lms_exam_attempts do |t|
      t.references :lms_exam, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
      t.timestamps null: false
    end
  end
end
