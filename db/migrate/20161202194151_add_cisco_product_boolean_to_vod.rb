class AddCiscoProductBooleanToVod < ActiveRecord::Migration
  def change
    add_column :video_on_demands, :cisco_digital_learning, :boolean, default: false
  end
end
