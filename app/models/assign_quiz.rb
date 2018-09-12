# == Schema Information
#
# Table name: assign_quizzes
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  lms_exam_id     :integer
#  video_module_id :integer
#  position        :integer
#

class AssignQuiz < ActiveRecord::Base
  belongs_to :video_module
  belongs_to :lms_exam
 
end
