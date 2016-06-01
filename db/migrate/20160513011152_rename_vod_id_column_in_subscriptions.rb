class RenameVodIdColumnInSubscriptions < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :video_on_demands_id, :video_on_demand_id
  end
end
