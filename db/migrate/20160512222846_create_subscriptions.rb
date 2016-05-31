class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.date :date_exp
      t.timestamps null: false
    end
  end
end
