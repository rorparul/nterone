class AddAttributesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :cost_instructor, :decimal, precision: 8, scale: 2
    add_column :events, :cost_lab, :decimal, precision: 8, scale: 2
    add_column :events, :cost_te, :decimal, precision: 8, scale: 2
    add_column :events, :cost_facility, :decimal, precision: 8, scale: 2
    add_column :events, :cost_books, :decimal, precision: 8, scale: 2
    add_column :events, :cost_shipping, :decimal, precision: 8, scale: 2
  end
end
