class ChangeBookCostsName < ActiveRecord::Migration
  def change
    rename_column :events, :autocalculate_book_costs, :calculate_book_costs
  end
end
