class AddAddressTrackerToUser < ActiveRecord::Migration
  def change
    add_column :users, :same_addresses, :boolean, default: false
  end
end
