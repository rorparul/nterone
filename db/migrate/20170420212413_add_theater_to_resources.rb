class AddTheaterToResources < ActiveRecord::Migration
  def change
    add_column :users,  :theater, :integer
    add_column :carts,  :theater, :integer
    add_column :orders, :theater, :integer
    add_column :pages,  :theater, :integer
  end
end
