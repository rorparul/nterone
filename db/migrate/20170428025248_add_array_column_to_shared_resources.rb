class AddArrayColumnToSharedResources < ActiveRecord::Migration
  def change
    add_column :pages,    :active_regions, :text, array: true, default: []
    add_column :events,   :active_regions, :text, array: true, default: []
    add_column :articles, :active_regions, :text, array: true, default: []
    add_column :orders,   :active_regions, :text, array: true, default: []
    add_column :carts,    :active_regions, :text, array: true, default: []
    add_column :users,    :active_regions, :text, array: true, default: []
  end
end
