class AddDefaultToCosts < ActiveRecord::Migration
  def change
    change_column :events, :cost_instructor, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :events, :cost_lab, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :events, :cost_te, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :events, :cost_facility, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :events, :cost_books, :decimal, precision: 8, scale: 2, default: 0.0
    change_column :events, :cost_shipping, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
