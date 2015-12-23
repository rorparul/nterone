class CategoryCourse < ActiveRecord::Base
  belongs_to :category
  belongs_to :course

  validates :category_id, uniqueness: { scope: :course_id }
end
