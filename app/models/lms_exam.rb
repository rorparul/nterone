# == Schema Information
#
# Table name: lms_exams
#
#  id                 :integer          not null, primary key
#  title              :string
#  description        :text
#  exam_type          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_module_id    :integer
#  video_id           :integer
#  slug               :string
#  video_on_demand_id :integer
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#
# Indexes
#
#  index_lms_exams_on_origin_region       (origin_region)
#  index_lms_exams_on_video_id            (video_id)
#  index_lms_exams_on_video_module_id     (video_module_id)
#  index_lms_exams_on_video_on_demand_id  (video_on_demand_id)
#
# Foreign Keys
#
#  fk_rails_...  (video_id => videos.id)
#  fk_rails_...  (video_module_id => video_modules.id)
#  fk_rails_...  (video_on_demand_id => video_on_demands.id)
#

class LmsExam < ActiveRecord::Base
	extend FriendlyId
  include Regions

  enum exam_type: [:quiz, :test]

  has_many :lms_exam_question_joins, dependent: :destroy
  has_many :lms_exam_questions, through: :lms_exam_question_joins
  has_many :lms_exam_attempts, dependent: :destroy

  belongs_to :video_on_demand


  validates :title, :description, :exam_type, presence: true

  accepts_nested_attributes_for :lms_exam_questions, reject_if: :all_blank, allow_destroy: true

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :title,
      [:title, :origin_region]
    ]
  end

  def completed_by?(user)
    completed = false
    attempts = lms_exam_attempts.where(user: user)

    attempts.each do |attempt|
      completed = true if attempt.lms_exam_attempt_answers.count == lms_exam_questions.count
    end

    completed
  end

  def attempt_count_for(user)
    lms_exam_attempts.where(user: user).count
  end

  def status_for(user)
    return 'completed' if completed_by?(user)
    return "tried #{attempt_count_for(user)} times" if attempt_count_for(user) > 0
    return 'never started'
  end
end
