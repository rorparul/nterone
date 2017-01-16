class AddNotesToOpportunities < ActiveRecord::Migration
  def change
    add_column :opportunities, :notes, :text
  end
end
