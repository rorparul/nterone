class AddCountWeekendsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :count_weekends, :boolean, default: false
  end
end
