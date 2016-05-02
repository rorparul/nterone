class LmsExam < ActiveRecord::Base
  enum exam_type: [:quiz, :test]
end
