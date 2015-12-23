class AddAbbToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :abbreviation, :string
  end
end
