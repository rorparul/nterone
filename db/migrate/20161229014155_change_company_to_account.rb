class ChangeCompanyToAccount < ActiveRecord::Migration
  def change
    rename_column :opportunities, :company_id, :account_id
  end
end
