class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.belongs_to :user
      t.boolean    :data_center
      t.boolean    :collaboration
      t.boolean    :network
      t.boolean    :security
      t.boolean    :associate_level_certification
      t.boolean    :professional_level_certification
      t.boolean    :expert_level_certification
      t.string     :other
      t.timestamps null: false
    end
  end
end
