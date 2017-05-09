class RenameTheaterColumns < ActiveRecord::Migration
  def change
    rename_column :pages,    :theater, :origin_region
    rename_column :events,   :theater, :origin_region
    rename_column :articles, :theater, :origin_region
    rename_column :orders,   :theater, :origin_region
    rename_column :carts,    :theater, :origin_region
    rename_column :users,    :theater, :origin_region
  end
end
