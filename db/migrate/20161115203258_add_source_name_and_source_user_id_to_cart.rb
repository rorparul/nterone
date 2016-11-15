class AddSourceNameAndSourceUserIdToCart < ActiveRecord::Migration
  def change
    add_column :carts, :source_name,    :string
    add_column :carts, :source_user_id, :string
    add_column :carts, :source_hash,    :string
  end
end
