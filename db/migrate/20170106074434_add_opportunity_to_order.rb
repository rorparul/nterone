class AddOpportunityToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :opportunity_id, :integer
  end
end
