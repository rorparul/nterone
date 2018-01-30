class AddBookCostToEvent < ActiveRecord::Migration
  def change
    add_column :events, :book_cost_per_student, :decimal, default: 0.0 
  end
end
