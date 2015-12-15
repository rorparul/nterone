class ChangeBrandUserToRole < ActiveRecord::Migration
  def change
    rename_table :brand_users, :roles
  end
end
