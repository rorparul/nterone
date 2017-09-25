class AddCommissionToEvent < ActiveRecord::Migration
  def change
    add_column :events, :commission_override, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
