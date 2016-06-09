class AddReferringPartnerEmailToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :referring_partner_email, :string
  end
end
