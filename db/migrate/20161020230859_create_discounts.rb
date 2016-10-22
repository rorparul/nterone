class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.boolean :active
      t.date :date_end
      t.date :date_start
      t.integer :limit
      t.string :code
      t.string :kind
      t.decimal :value
    end
  end
end
