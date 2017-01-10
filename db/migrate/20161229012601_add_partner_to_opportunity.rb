class AddPartnerToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :partner_id, :integer
  end
end
