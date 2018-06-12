class ChangeTermsDatatype < ActiveRecord::Migration
  def change
    change_column :lab_rentals, :terms, :string
    change_column :lab_rentals, :confirmed, :boolean, default: false
    change_column :lab_rentals, :twenty_four_hours, :boolean, default: false
    change_column :lab_rentals, :plus_instructor, :boolean, default: false
    change_column :lab_rentals, :entered_into_crm, :boolean, default: false
    change_column :lab_rentals, :payment_received, :boolean, default: false
  end
end
