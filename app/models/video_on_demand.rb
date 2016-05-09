class VideoOnDemand < ActiveRecord::Base
  extend FriendlyId
  include Imageable

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title]
    ]
  end

  belongs_to :platform
  belongs_to :course #TODO remove after transfer
  belongs_to :instructor

  has_many :order_items,               as: :orderable
  has_many :orders,                    through: :order_items
  has_many :category_video_on_demands, dependent: :destroy
  has_many :categories,                through: :category_video_on_demands
  has_many :video_modules,             dependent: :destroy
  has_many :videos,                    through: :video_modules
  has_many :users,                     through: :order_items

  has_one :image, as: :imageable, dependent: :destroy
  has_one :lms_exam

  accepts_nested_attributes_for :image

  accepts_nested_attributes_for :video_modules, reject_if: :all_blank, allow_destroy: true

  before_destroy :ensure_not_purchased_or_in_cart

  validates :title, :abbreviation, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_associated :categories

  scope :lms, -> { where(lms: true) }

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end

  def purchased_by?(user)
    return false if ! user
    day = Date.today - 365.day
    order_items.exists?(['user_id=? AND created_at>=?', user.id, day])
  end

  def video_count
    video_modules.inject(0) do |result, video_module|
      result + video_module.videos.length
    end
  end

  def watched_count(user)
    video_modules.inject(0) do |result, video_module|
      result + video_module.watched_count(user)
    end
  end

  def quizes
    ids = video_modules.pluck(:id)
    LmsExam.where(video_module_id: ids, exam_type: 0)
  end

  def all_exams
    ids = video_modules.pluck(:id)
    LmsExam.where(video_module_id: ids)
  end

  def quizes_count
    self.quizes.count
  end

  def quizes_completed_count_by(user)
    self.quizes.inject(0) do |sum, quiz|
      quiz.completed_by?(user) ? sum + 1 : sum
    end
  end

  def exam_completed_by?(user)
    ids = video_modules.pluck(:id)
    exam = LmsExam.where(video_module_id: ids, exam_type: 1).first

    exam.present? ? exam.completed_by?(user) : false
  end

  def exam_attempts_for(user)
    exam_ids = self.all_exams.pluck(:id)

    LmsExamAttempt.where(user: user, lms_exam_id: exam_ids)
  end

  private

  def ensure_not_purchased_or_in_cart
    if users.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end
end
