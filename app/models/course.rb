class Course < ActiveRecord::Base
  extend FriendlyId
  mount_uploader :pdf, PdfUploader
  include Imageable

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [
      :abbreviation,
      [:abbreviation, :title]
    ]
  end

  belongs_to :platform

  has_many :category_courses,         dependent: :destroy
  has_many :categories,               through: :category_courses
  has_many :group_items,              as: :groupable, dependent: :destroy
  has_many :course_dynamics,          dependent: :destroy
  has_many :exam_and_course_dynamics, through: :course_dynamics
  has_many :chosen_courses,           dependent: :destroy
  has_many :users,                    through: :chosen_courses
  has_many :testimonials
  has_many :events,                   dependent: :destroy
  has_many :video_on_demands,         dependent: :destroy

  has_one  :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :categories, :title, :abbreviation, presence: true
  validates_associated :categories

  def active_events
    events.where(active: true).order(:start_date)
  end

  def upcoming_events
    events.where('active = ? and start_date >= ?', true, Date.today).order(:start_date)
  end

  def upcoming_public_events
    events.where('active = ? and public = ? and start_date >= ?', true, true, Date.today).order(:start_date)
  end

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end
end
