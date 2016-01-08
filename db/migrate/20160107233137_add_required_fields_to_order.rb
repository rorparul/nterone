class AddRequiredFieldsToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :first_name,  :string
    add_column :orders, :last_name,   :string
    add_column :orders, :street,      :string
    add_column :orders, :city,        :string
    add_column :orders, :state,       :string
    add_column :orders, :postal_code, :string
    add_column :orders, :country,     :string
    add_column :orders, :email,       :string
  end
end
