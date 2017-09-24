class CreateContactUsSubmissions < ActiveRecord::Migration
  def change
    create_table :contact_us_submissions do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :inquiry
      t.string :feedback
      t.timestamps null: false
    end
  end
end
