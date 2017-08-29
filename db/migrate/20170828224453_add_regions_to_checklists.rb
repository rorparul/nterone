class AddRegionsToChecklists < ActiveRecord::Migration
  def change
    add_column :checklists, :active_regions, :text, array: true, default: []
    add_column :checklists, :origin_region, :integer
  end
end
