class AddColumnsToLabRentals < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :setup_by, :integer
    add_column :lab_rentals, :tested_by, :integer
    add_column :lab_rentals, :lab, :string
    add_column :lab_rentals, :partner, :string
    add_column :lab_rentals, :gmt, :string
    add_column :lab_rentals, :number_of_pods, :integer
    add_column :lab_rentals, :number_of_students, :integer
    add_column :lab_rentals, :plus_instructor, :boolean
    add_column :lab_rentals, :price, :decimal
    add_column :lab_rentals, :po_number, :integer
    add_column :lab_rentals, :entered_into_crm, :boolean
    add_column :lab_rentals, :invoice_number, :string
    add_column :lab_rentals, :payment_received, :boolean
    add_column :lab_rentals, :poc, :string
    add_column :lab_rentals, :terms, :boolean
  end
end
