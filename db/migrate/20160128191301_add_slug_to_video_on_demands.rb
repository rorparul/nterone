class AddSlugToVideoOnDemands < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :slug, :string
    add_index  :video_on_demands, :slug
  end
end
