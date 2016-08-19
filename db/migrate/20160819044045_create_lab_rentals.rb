class CreateLabRentals < ActiveRecord::Migration
  def change
    create_table :lab_rentals do |t|
    	t.references :course, index: true, foreign_key: true
    	t.date :first_day
    	t.integer :num_of_students, default: 0
    	t.time :start_time
    	t.string :instructor
    	t.string :instructor_email
    	t.string :instructor_phone
    	t.text :notes
    	t.string :location
    	t.boolean :confirmed
    	t.timestamps null: false
    end
  end
end