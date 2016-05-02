class RemovePlatformIdFromExams < ActiveRecord::Migration
  def change
    remove_column :exams, :platform_id, :integer
  end
end
