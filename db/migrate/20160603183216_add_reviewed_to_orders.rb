class AddReviewedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :reviewed, :boolean, default: false
  end
end
