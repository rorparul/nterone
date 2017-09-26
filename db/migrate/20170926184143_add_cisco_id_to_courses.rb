class AddCiscoIdToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :cisco_id, :integer
  end
end
