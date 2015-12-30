class Course < ActiveRecord::Base
  mount_uploader :course_info, CourseInfoUploader

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

  def active_events
    events.where(active: true)
  end

  def any_guaranteed_to_run_events?
    self.events.any? { |event| event.guaranteed }
  end

  def self.with_guaranteed_to_run_events
    all.order(:platform_id, :title).select do |course|
      course if course.events.any? { |event| event.guaranteed }
    end
  end

  private

  def format_url
    self.url.gsub!(/(http:\/\/)|(https:\/\/)|(http:\/\/www.)|((https:\/\/)www.)|(www.)/, '') if self.url
  end
end
