class AddIndexPlatform < ActiveRecord::Migration
  def change
    add_index :platforms, :slug
  end
end
