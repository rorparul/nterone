class AddDateEndToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :date_closed, :date
  end
end
