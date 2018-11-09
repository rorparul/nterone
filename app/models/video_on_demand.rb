# == Schema Information
#
# Table name: video_on_demands
#
#  id                        :integer          not null, primary key
#  course_id                 :integer
#  instructor_id             :integer
#  level                     :string
#  price                     :decimal(8, 2)    default(0.0)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  platform_id               :integer
#  title                     :string
#  abbreviation              :string
#  slug                      :string
#  page_title                :string
#  page_description          :text
#  intro                     :text
#  overview                  :text
#  outline                   :text
#  intended_audience         :text
#  partner_led               :boolean          default(FALSE)
#  active                    :boolean          default(TRUE)
#  lms                       :boolean          default(FALSE)
#  heading                   :string
#  satellite_viewable        :boolean          default(TRUE)
#  cisco_digital_learning    :boolean          default(FALSE)
#  cdl_course_code           :string
#  origin_region             :integer
#  active_regions            :text             default([]), is an Array
#  cisco_course_product_code :string
#  archived                  :boolean          default(FALSE)
#
# Indexes
#
#  index_video_on_demands_on_origin_region  (origin_region)
#  index_video_on_demands_on_slug           (slug)
#

class VideoOnDemand < ActiveRecord::Base
  extend FriendlyId
  include Imageable
  include Regions

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title],
      [:abbreviation, :title, :origin_region]
    ]
  end

  belongs_to :platform
  belongs_to :course #TODO remove after transfer
  belongs_to :instructor, class_name: 'User'

  has_many :order_items,               as:        :orderable
  has_many :orders,                    through:   :order_items
  has_many :category_video_on_demands, dependent: :destroy
  has_many :categories,                through:   :category_video_on_demands
  has_many :video_modules,             dependent: :destroy
  has_many :videos,                    through:   :video_modules
  has_many :users,                     through:   :order_items
  has_one :image, as: :imageable, dependent: :destroy
  has_many :lms_exams
  accepts_nested_attributes_for :image

  accepts_nested_attributes_for :video_modules, reject_if: :all_blank, allow_destroy: true

  before_destroy :ensure_not_purchased_or_in_cart

  validates :title, :abbreviation, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }
  validates_associated :categories

  after_initialize :set_all_regions, if: :new_record?

  scope :active, -> { where(archived: false) }
  scope :lms, -> { where(lms: true) }

  def self.search(query)
    where("LOWER(title) like :q OR LOWER(abbreviation) like :q", q: "%#{query.try(:downcase)}%").where.not(lms: true)
  end

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
    order_items.exists?(['user_id = ? AND created_at >= ?', user.id, day])
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
    lms_exam_id = AssignQuiz.where(video_module_id: ids).map(&:lms_exam_id).uniq
    LmsExam.where(id: lms_exam_id, exam_type: 0)
  end

  def all_exams
    ids = video_modules.pluck(:id)
    AssignQuiz.where(video_module_id: ids).map(&:lms_exam_id).uniq
  end

  def all_videos
    ids = video_modules.pluck(:id)
    Video.where(video_module_id: ids)
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
    lms_exams.each do |lms_exam|
      lms_exam.present? ? lms_exam.completed_by?(user) : false
    end
  end

  def exam_attempts_for(user)
    exam_ids = self.all_exams
    LmsExamAttempt.where(user: user, lms_exam_id: exam_ids)
  end

  def overal_progress_percent_for(user)
    return 0 if overal_all_count_for(user).zero?

    all_count = self.all_exams.count + self.video_count
    completed_count = self.quizes_completed_count_by(user) + self.watched_count(user)

    (overal_progress_count_for(user) * 100) / overal_all_count_for(user)
  end

  def overal_all_count_for(user)
    self.all_exams.count + self.video_count
  end

  def overal_progress_count_for(user)
    self.quizes_completed_count_by(user) + self.watched_count(user)
  end

  def assigned_to?(user)
    AssignedItem.exists?(student: user, item: self)
  end


  private

  def ensure_not_purchased_or_in_cart
    if order_items.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end
end
