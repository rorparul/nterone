class AddDefaultToEventStatus < ActiveRecord::Migration
  def change
    change_column :events, :status, :string, default: "Pending"
  end
end
