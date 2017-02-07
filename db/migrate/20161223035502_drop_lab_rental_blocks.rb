class DropLabRentalBlocks < ActiveRecord::Migration
  def change
    drop_table :lab_rental_blocks
  end
end
