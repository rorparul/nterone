class CreateInstructors < ActiveRecord::Migration
  def change
    create_table :instructors do |t|
      t.string :first_name
      t.string :last_name
      t.string :biography
      t.string :email
      t.string :phone
      t.timestamps null: false
    end
  end
end
