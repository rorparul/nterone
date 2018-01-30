class ChangeBookCosts < ActiveRecord::Migration
  def change
    change_column :events, :book_cost_per_student, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
