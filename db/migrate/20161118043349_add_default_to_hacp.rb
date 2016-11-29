class AddDefaultToHacp < ActiveRecord::Migration
  def change
    change_column :hacp_requests, :used, :boolean, default: false
  end
end
