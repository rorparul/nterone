class RemoveFileFromTopology < ActiveRecord::Migration
  def change
    remove_column :topologies, :file
  end
end
