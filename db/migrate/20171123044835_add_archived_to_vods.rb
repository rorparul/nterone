class AddArchivedToVods < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :archived, :boolean, default: false
  end
end
