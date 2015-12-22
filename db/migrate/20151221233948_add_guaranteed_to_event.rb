class AddGuaranteedToEvent < ActiveRecord::Migration
  def change
    add_column :events, :guaranteed, :boolean, default: false
  end
end
