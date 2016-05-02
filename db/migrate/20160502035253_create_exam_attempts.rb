class CreateExamAttempts < ActiveRecord::Migration
  def change
    create_table :exam_attempts do |t|
      t.references :exam, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :started_at
      t.datetime :completed_at
    end
  end
end
