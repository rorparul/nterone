class AddTotalToOrdersAndDefaultStatus < ActiveRecord::Migration
  def change
    change_column :orders, :status, :string,  default: 'uninvoiced'
    change_column :orders, :paid,   :decimal, precision: 8, scale: 2, default: 0.0
    add_column    :orders, :total,  :decimal, precision: 8, scale: 2, default: 0.0
  end
end
