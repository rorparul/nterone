class ExpandAttributesForCourses < ActiveRecord::Migration
  def change
    add_column :courses, :active,            :boolean, default: true
    add_column :courses, :abbreviation,      :string
    add_column :courses, :sku,               :string
    add_column :courses, :length,            :string
    add_column :courses, :intro,             :text
    add_column :courses, :overview,          :text
    add_column :courses, :outline,           :text
    add_column :courses, :intended_audience, :text
  end
end
