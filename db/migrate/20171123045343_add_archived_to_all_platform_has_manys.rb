class AddArchivedToAllPlatformHasManys < ActiveRecord::Migration
  def change
    add_column :categories,               :archived, :boolean, default: false
    add_column :subjects,                 :archived, :boolean, default: false
    add_column :exams,                    :archived, :boolean, default: false
    add_column :events,                   :archived, :boolean, default: false
    add_column :dividers,                 :archived, :boolean, default: false
    add_column :custom_items,             :archived, :boolean, default: false
    add_column :exam_and_course_dynamics, :archived, :boolean, default: false
    add_column :instructors,              :archived, :boolean, default: false
  end
end
