class AddTitleToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :title, :string
  end
end
