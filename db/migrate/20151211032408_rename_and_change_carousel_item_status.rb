class RenameAndChangeCarouselItemStatus < ActiveRecord::Migration
  def change
    remove_column :carousel_items, :status
    add_column    :carousel_items, :active, :boolean, default: true
  end
end
