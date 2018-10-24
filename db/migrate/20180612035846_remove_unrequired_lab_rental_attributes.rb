class RemoveUnrequiredLabRentalAttributes < ActiveRecord::Migration
  def change
    remove_column :lab_rentals, :lab, :string
    remove_column :lab_rentals, :partner, :string
    remove_column :lab_rentals, :gmt, :string
    remove_column :lab_rentals, :number_of_students, :string
  end
end
