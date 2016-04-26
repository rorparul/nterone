class AddPoPaidToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :po_paid, :string
  end
end
