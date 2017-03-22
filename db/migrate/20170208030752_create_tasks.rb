class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.datetime :activity_date
      t.text :description
      t.integer :rep_id
      t.integer :priority
      t.integer :status
      t.string :subject
      t.integer :user_id
    end
  end
end
