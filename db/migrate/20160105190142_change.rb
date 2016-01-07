class Change < ActiveRecord::Migration
  def change
    change_column :events, :price, :decimal, precision: 8, scale: 2
  end
end
