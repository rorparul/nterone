class CreateOpportunities < ActiveRecord::Migration
  def change
    create_table :opportunities do |t|
      t.integer :employee_id
      t.integer :customer_id
      t.belongs_to :company
      t.string :title
      t.integer :stage
      t.decimal :amount, precision: 8, scale: 2, default: 0.0
      t.string :kind
      t.string :reason_for_loss

      t.timestamps null: false
    end
  end
end
