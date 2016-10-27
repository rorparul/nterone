class AddDefaultToActive < ActiveRecord::Migration
  def change
    change_column :discounts, :active, :boolean, default: true
  end
end
