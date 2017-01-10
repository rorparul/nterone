class AddLeadStuffToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_alternative, :string
    add_column :users, :phone_alternative, :string
    add_column :users, :notes, :text
    add_column :users, :aasm_state, :string
  end
end
