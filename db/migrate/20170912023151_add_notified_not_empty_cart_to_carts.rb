class AddNotifiedNotEmptyCartToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :notified_not_empty_cart_at, :datetime, default: nil
  end
end
