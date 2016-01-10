class AddUrlToCarousel < ActiveRecord::Migration
  def change
    add_column :carousel_items, :url, :string
  end
end
