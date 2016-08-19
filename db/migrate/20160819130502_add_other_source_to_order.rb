class AddOtherSourceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :other_source, :string
  end
end
