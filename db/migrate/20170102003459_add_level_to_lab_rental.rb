class AddLevelToLabRental < ActiveRecord::Migration
  def change
    add_column :lab_rentals, :level, :string
  end
end
