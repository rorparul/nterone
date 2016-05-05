class LmsExam < ActiveRecord::Base
	extend FriendlyId

  enum exam_type: [:quiz, :test]

  has_many :lms_exam_question_joins
  has_many :lms_exam_questions, through: :lms_exam_question_joins
  has_many :lms_exam_attempts

  belongs_to :video_module
  belongs_to :video

  validates :title, :description, :exam_type, presence: true

  accepts_nested_attributes_for :lms_exam_questions, reject_if: :all_blank, allow_destroy: true

  friendly_id :title, use: [:slugged, :finders]
end
