class ExamDynamic < ActiveRecord::Base
  belongs_to :exam_and_course_dynamic
  belongs_to :exam
end
