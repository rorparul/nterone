class AddNewAttributesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :status,     :string
    add_column :events, :lab_source, :string
    add_column :events, :public,     :boolean
  end
end
