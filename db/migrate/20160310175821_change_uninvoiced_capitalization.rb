class ChangeUninvoicedCapitalization < ActiveRecord::Migration
  def change
    change_column_default :orders, :status, "Uninvoiced"
  end
end
