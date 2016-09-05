class AddFormTypeToLabRental < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :kind, :integer
  end
end
