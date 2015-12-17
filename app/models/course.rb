class Course < ActiveRecord::Base
  belongs_to :platform

  has_many :category_courses,         dependent: :destroy
  has_many :categories,               through: :category_courses
  has_many :group_items,              as: :groupable, dependent: :destroy
  has_many :course_dynamics,          dependent: :destroy
  has_many :exam_and_course_dynamics, through: :course_dynamics
  has_many :chosen_courses,           dependent: :destroy
  has_many :users,                    through: :chosen_courses
  has_many :testimonials

  before_save :format_url

  private

  def format_url
    self.url.gsub!(/(http:\/\/)|(https:\/\/)|(http:\/\/www.)|((https:\/\/)www.)|(www.)/, '') if self.url
  end
end
