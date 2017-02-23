class CreateTopology < ActiveRecord::Migration
  def change
    create_table :topologies do |t|
      t.integer :lab_course_id
      t.string :file

      t.timestamps
    end
  end
end
