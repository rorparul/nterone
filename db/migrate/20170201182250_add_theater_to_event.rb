class AddTheaterToEvent < ActiveRecord::Migration
  def change
    add_column :events, :theater, :integer
  end
end
