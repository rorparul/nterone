class AddPositionToModuleAndVideo < ActiveRecord::Migration
  def change
    add_column :video_modules, :position, :integer, default: 0
    add_column :videos, :position, :integer, default: 0
  end
end
