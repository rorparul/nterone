class CreateAssignedItems < ActiveRecord::Migration
  def change
    create_table :assigned_items do |t|
      t.integer :assigner_id
      t.integer :student_id
      t.references :item, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
