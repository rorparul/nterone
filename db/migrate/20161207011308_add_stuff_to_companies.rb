class AddStuffToCompanies < ActiveRecord::Migration
  def up
    add_column :companies, :user_id,  :integer
    add_column :companies, :kind,     :string
    add_column :companies, :street,   :string
    add_column :companies, :city,     :string
    add_column :companies, :state,    :string
    add_column :companies, :zip_code, :string
    add_column :companies, :phone,    :string
    add_column :companies, :website,  :string
  end

  def down
  end
end
