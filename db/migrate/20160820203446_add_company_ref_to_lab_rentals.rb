class AddCompanyRefToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :company_id, :integer
  end
end
