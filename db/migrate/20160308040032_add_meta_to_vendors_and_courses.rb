class AddMetaToVendorsAndCourses < ActiveRecord::Migration
  def change
    add_column :platforms,        :page_title,       :string
    add_column :platforms,        :page_description, :text
    add_column :subjects,         :page_title,       :string
    add_column :subjects,         :page_description, :text
    add_column :courses,          :page_title,       :string
    add_column :courses,          :page_description, :text
    add_column :video_on_demands, :page_title,       :string
    add_column :video_on_demands, :page_description, :text
  end
end
