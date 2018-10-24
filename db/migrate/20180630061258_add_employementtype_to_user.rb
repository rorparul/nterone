class AddEmployementtypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :employement_type, :integer
  end
end
