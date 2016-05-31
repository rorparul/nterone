class AddStatusPositionToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :status_position, :integer
  end
end
