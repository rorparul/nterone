class AddEmailToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :email_optional, :string
  end
end
