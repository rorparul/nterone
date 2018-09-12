class AddMultipleIdsToAssignQuizes < ActiveRecord::Migration
  def change
    add_column :assign_quizes, :lms_exam_id, :integer
    add_column :assign_quizes, :video_id, :integer
  end
end
