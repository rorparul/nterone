class VodPriceFormat < ActiveRecord::Migration
  def change
    change_column :video_on_demands, :price, :decimal, precision: 8, scale: 2
  end
end
