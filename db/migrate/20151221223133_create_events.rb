class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date    :start_date
      t.date    :end_date
      t.string  :format
      t.integer :price
      t.belongs_to :instructor
      t.belongs_to :course
      t.timestamps null: false
    end
  end
end
