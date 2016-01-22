class Prune < ActiveRecord::Migration
  def change
    drop_table :subscriptions
    drop_table :attendances
  end
end
