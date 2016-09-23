class AddDefaultBookCostToEvents < ActiveRecord::Migration
  def change
    add_column :events, :default_book_cost, :boolean, :default => true
  end
end
