class CreateLabStudents < ActiveRecord::Migration
  def change
    create_table :lab_students do |t|
      t.belongs_to :lab_rental
      t.string     :name
      t.string     :email
      t.timestamps null: false
    end
  end
end
