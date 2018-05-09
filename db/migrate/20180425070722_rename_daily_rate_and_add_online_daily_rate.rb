class RenameDailyRateAndAddOnlineDailyRate < ActiveRecord::Migration
  def change
    rename_column :users, :daily_rate, :onsite_daily_rate
    add_column :users, :online_daily_rate, :decimal, precision: 8, scale: 2, default: 0.0
  end
end
