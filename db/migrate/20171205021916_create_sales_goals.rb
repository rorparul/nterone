class CreateSalesGoals < ActiveRecord::Migration
  def change
    create_table :sales_goals do |t|
      t.date :month
      t.integer :amount
      t.text :description
      t.integer :origin_region

      t.timestamps null: false
    end
  end
end
