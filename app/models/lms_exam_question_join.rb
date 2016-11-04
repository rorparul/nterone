class LmsExamQuestionJoin < ActiveRecord::Base
  belongs_to :lms_exam
  belongs_to :lms_exam_question
end
