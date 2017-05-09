class AddCourseAndEventToOpportunity < ActiveRecord::Migration
  def change
    add_column :opportunities, :course_id, :integer
    add_column :opportunities, :event_id,  :integer
  end
end
