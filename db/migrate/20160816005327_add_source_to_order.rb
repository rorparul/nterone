class AddSourceToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :source, :integer, :default => 0
  end
end
