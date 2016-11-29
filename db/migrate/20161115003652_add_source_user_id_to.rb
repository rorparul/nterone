class AddSourceUserIdTo < ActiveRecord::Migration
  def change
    add_column :users, :source_name, :string
    add_column :users, :source_user_id, :string
  end
end
