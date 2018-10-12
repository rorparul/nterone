class AddProviderToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :provider, :string, default: ''
  end
end
