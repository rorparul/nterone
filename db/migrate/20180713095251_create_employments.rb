class CreateEmployments < ActiveRecord::Migration
  def change
    create_table :employments do |t|
      t.string :start_date
      t.string :string
      t.string :end_date
      t.string :type

      t.timestamps null: false
    end
  end
end