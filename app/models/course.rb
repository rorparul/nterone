class Course < ActiveRecord::Base
  include Bootsy::Container
  mount_uploader :pdf, PdfUploader

  belongs_to :platform

  has_many :category_courses,         dependent: :destroy
  has_many :categories,               through: :category_courses
  has_many :group_items,              as: :groupable, dependent: :destroy
  has_many :course_dynamics,          dependent: :destroy
  has_many :exam_and_course_dynamics, through: :course_dynamics
  has_many :chosen_courses,           dependent: :destroy
  has_many :users,                    through: :chosen_courses
  has_many :testimonials
  has_many :events
  has_many :video_on_demands

  before_save :format_url

  validates :categories, :title, :abbreviation, presence: true
  validates_associated :categories

  def active_events
    events.where(active: true).order(:start_date)
  end

  def upcoming_events
    events.where('active = ? and start_date >= ?', true, Date.today).order(:start_date)
  end

  private

  def format_url
    self.url.gsub!(/(http:\/\/)|(https:\/\/)|(http:\/\/www.)|((https:\/\/)www.)|(www.)/, '') if self.url
  end
end
