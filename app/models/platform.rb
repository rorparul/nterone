class Platform < ActiveRecord::Base
  include Imageable

  has_many :categories, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :groups
  has_many :exams
  has_many :courses
  has_many :dividers
  has_many :custom_items
  has_many :exam_and_course_dynamics
  has_many :instructors
  has_many :video_on_demands

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  delegate :parent_categories, to: :categories

  def self.with_guaranteed_to_run_courses
    order(:title).select do |platform|
      platform.courses.any? do |course|
        course.any_guaranteed_to_run_events?
      end
    end
  end
end
