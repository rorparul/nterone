# == Schema Information
#
# Table name: lms_exam_attempts
#
#  id             :integer          not null, primary key
#  lms_exam_id    :integer
#  user_id        :integer
#  started_at     :datetime
#  completed_at   :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_lms_exam_attempts_on_lms_exam_id  (lms_exam_id)
#  index_lms_exam_attempts_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_17dcfcfc42  (user_id => users.id)
#  fk_rails_c363284271  (lms_exam_id => lms_exams.id)
#

class LmsExamAttempt < ActiveRecord::Base
  include Regions

  belongs_to :lms_exam
  belongs_to :user

  has_many :lms_exam_attempt_answers, dependent: :destroy

  def number_correct
    num_correct = 0

    lms_exam_attempt_answers.each do |attempt_answer|
      num_correct += 1 if attempt_answer.correct?
    end

    num_correct
  end

  def question_count
    self.lms_exam.lms_exam_questions.length
  end

  def percent_correct
    (self.number_correct * 100) / question_count
  end
end
