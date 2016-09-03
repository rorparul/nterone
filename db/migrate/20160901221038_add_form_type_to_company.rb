class AddFormTypeToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :form_type, :string
  end
end
