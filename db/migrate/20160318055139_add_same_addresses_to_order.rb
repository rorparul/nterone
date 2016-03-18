class AddSameAddressesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :same_address, :boolean, default: false
  end
end
