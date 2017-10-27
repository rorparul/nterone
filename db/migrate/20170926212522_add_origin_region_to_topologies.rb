class AddOriginRegionToTopologies < ActiveRecord::Migration
  def change
    add_column :topologies, :origin_region, :integer
  end
end
