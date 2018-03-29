# == Schema Information
#
# Table name: lms_exam_question_joins
#
#  id                   :integer          not null, primary key
#  lms_exam_id          :integer
#  lms_exam_question_id :integer
#  position             :integer
#  active               :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  origin_region        :integer
#  active_regions       :text             default([]), is an Array
#
# Indexes
#
#  index_lms_exam_question_joins_on_lms_exam_id           (lms_exam_id)
#  index_lms_exam_question_joins_on_lms_exam_question_id  (lms_exam_question_id)
#  index_lms_exam_question_joins_on_origin_region         (origin_region)
#
# Foreign Keys
#
#  fk_rails_...  (lms_exam_id => lms_exams.id)
#  fk_rails_...  (lms_exam_question_id => lms_exam_questions.id)
#

class LmsExamQuestionJoin < ActiveRecord::Base
  include Regions

  belongs_to :lms_exam
  belongs_to :lms_exam_question
end
