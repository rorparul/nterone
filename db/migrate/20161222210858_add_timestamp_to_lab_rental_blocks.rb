class AddTimestampToLabRentalBlocks < ActiveRecord::Migration
  def change
    add_column :lab_rental_blocks, :created_at, :datetime, null: false
    add_column :lab_rental_blocks, :updated_at, :datetime, null: false
  end
end
