class ChangeCourseStringToAssociationOnTestimonials < ActiveRecord::Migration
  def change
    remove_column :testimonials, :course
    add_column    :testimonials, :course_id, :integer
  end
end
