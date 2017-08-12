class CreateChecklistItems < ActiveRecord::Migration
  def change
    create_table :checklist_items do |t|
      t.belongs_to :checklist, index: true, foreign_key: true
      t.text :content
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
