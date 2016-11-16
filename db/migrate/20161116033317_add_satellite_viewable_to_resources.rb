class AddSatelliteViewableToResources < ActiveRecord::Migration
  def change
    add_column :platforms,        :satellite_viewable, :boolean, default: true
    add_column :courses,          :satellite_viewable, :boolean, default: true
    add_column :video_on_demands, :satellite_viewable, :boolean, default: true
  end
end
