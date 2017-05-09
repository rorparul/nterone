class AddParentToCompany < ActiveRecord::Migration
  def up
    add_column :companies, :parent_id, :integer
  end
end
