class AddResellToEvents < ActiveRecord::Migration
  def change
    add_column :events, :resell, :boolean, default: false
  end
end
