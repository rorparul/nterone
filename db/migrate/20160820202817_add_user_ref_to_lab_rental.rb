class AddUserRefToLabRental < ActiveRecord::Migration
  def change
    add_column    :lab_rentals, :user_id, :integer
    remove_column :lab_rentals, :company_id
  end
end
