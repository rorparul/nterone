class LmsExam < ActiveRecord::Base
	extend FriendlyId

  enum exam_type: [:quiz, :test]

  has_many :taken_exams, dependent: :destroy
  has_many :users,       through: :taken_exams
  has_many :lms_exam_question_joins, dependent: :destroy
  has_many :lms_exam_questions, through: :lms_exam_question_joins
  has_many :lms_exam_attempts, dependent: :destroy

  belongs_to :video_module
  belongs_to :video

  validates :title, :description, :exam_type, presence: true

  accepts_nested_attributes_for :lms_exam_questions, reject_if: :all_blank, allow_destroy: true

  friendly_id :title, use: [:slugged, :finders]

  def completed_by?(user)
    completed = false
    attempts = lms_exam_attempts.where(user: user)

    attempts.each do |attempt|
      completed = true if attempt.lms_exam_attempt_answers.count == lms_exam_questions.count
    end

    completed
  end
end
