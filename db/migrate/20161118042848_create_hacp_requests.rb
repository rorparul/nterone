class CreateHacpRequests < ActiveRecord::Migration
  def change
    create_table :hacp_requests do |t|
      t.string :aicc_sid
      t.boolean :used
      t.timestamps null: false
    end
  end
end
