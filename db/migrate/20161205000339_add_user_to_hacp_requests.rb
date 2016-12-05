class AddUserToHacpRequests < ActiveRecord::Migration
  def change
    add_column :hacp_requests, :user_id, :integer
  end
end
