class AddTokenToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :token, :string
    add_index :carts, :token
  end
end
