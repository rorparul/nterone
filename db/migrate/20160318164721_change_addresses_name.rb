class ChangeAddressesName < ActiveRecord::Migration
  def change
    rename_column :orders, :same_address, :same_addresses
  end
end
