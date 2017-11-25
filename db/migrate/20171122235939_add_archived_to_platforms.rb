class AddArchivedToPlatforms < ActiveRecord::Migration
  def change
    add_column :platforms, :archived, :boolean, default: false
  end
end
