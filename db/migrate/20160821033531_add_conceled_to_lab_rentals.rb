class AddConceledToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :canceled, :boolean
  end
end
