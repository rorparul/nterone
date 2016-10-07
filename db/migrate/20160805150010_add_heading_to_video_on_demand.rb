class AddHeadingToVideoOnDemand < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :heading, :string
  end
end
