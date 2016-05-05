class CreateTakenExams < ActiveRecord::Migration
  def change
    create_table :taken_exams do |t|
    	t.references :lms_exam, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :status
      t.timestamps null: false
    end
  end
end
