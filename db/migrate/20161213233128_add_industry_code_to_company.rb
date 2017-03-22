class AddIndustryCodeToCompany < ActiveRecord::Migration
  def up
    add_column :companies, :industry_code, :string
  end
end
