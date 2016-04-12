class AddActiveToSubjectsAndVods < ActiveRecord::Migration
  def change
    add_column :subjects,         :active, :boolean, default: true
    add_column :video_on_demands, :active, :boolean, default: true
  end
end
