class AddSalesForceIdToUsersAndCompanies < ActiveRecord::Migration
  def change
    add_column :users,     :sales_force_id, :string
    add_column :companies, :sales_force_id, :string
  end
end
