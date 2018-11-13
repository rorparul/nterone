class AddSalesRepIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sales_rep_id, :integer
  end
end
