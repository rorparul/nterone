class Platform < ActiveRecord::Base
  extend FriendlyId
  include Imageable

  friendly_id :title, use: [:slugged, :finders]

  has_many :categories, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :courses, dependent: :destroy
  has_many :events, through: :courses
  has_many :dividers, dependent: :destroy
  has_many :custom_items, dependent: :destroy
  has_many :exam_and_course_dynamics, dependent: :destroy
  has_many :instructors, dependent: :destroy
  has_many :video_on_demands, dependent: :destroy

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  delegate :parent_categories, to: :categories

  validates :title, presence: true
  validates_associated :image

  def upcoming_events
    events.where("events.active = :active and start_date >= :start_date", { active: true, start_date: Date.today }).order(:start_date)
  end

  def featured_upcoming_events
    events.where("events.active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Date.today }).order(:start_date)
  end

  def upcoming_public_featured_events
    events.where("events.active = :active and public = :public and guaranteed = :guaranteed and start_date >= :start_date", { active: true, public: true, guaranteed: true, start_date: Date.today }).order(:start_date)
  end
end
