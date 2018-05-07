class AddContentForWelcomePageToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :featured_course_summary, :text, default: ''
  end
end
