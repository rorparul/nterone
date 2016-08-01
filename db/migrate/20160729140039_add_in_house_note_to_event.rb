class AddInHouseNoteToEvent < ActiveRecord::Migration
  def change
    add_column :events, :in_house_note, :text
  end
end
