class CourseDynamic < ActiveRecord::Base
  belongs_to :exam_and_course_dynamic
  belongs_to :course
end
