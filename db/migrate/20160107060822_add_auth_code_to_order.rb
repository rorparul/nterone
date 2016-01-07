class AddAuthCodeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :auth_code, :string
  end
end
