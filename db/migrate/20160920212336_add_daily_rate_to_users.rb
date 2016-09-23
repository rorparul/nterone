class AddDailyRateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_rate, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
