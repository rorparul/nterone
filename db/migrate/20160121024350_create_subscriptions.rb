class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :video_on_demand
      t.timestamps null: false
    end
  end
end
