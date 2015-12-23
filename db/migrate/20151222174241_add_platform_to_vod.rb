class AddPlatformToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :platform_id, :integer
  end
end
