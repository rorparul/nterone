class AddAttributesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :name_on_card,     :string
    add_column :orders, :billing_zip_code, :string
  end
end
