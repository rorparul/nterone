class AddLmsToVideoOnDemand < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :lms, :boolean, default: false
  end
end
