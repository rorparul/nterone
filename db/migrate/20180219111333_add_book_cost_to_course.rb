class AddBookCostToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :book_cost_per_student, :decimal, default: 0.0
  end
end
