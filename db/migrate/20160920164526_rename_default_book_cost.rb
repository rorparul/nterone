class RenameDefaultBookCost < ActiveRecord::Migration
  def change
    rename_column :events, :default_book_cost, :autocalculate_book_costs
  end
end
