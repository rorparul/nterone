class AddReferringPartnerToUser < ActiveRecord::Migration
  def change
    add_column :users, :referring_partner_email, :string
  end
end
