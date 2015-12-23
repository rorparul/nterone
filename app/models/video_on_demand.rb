class VideoOnDemand < ActiveRecord::Base
  belongs_to :platform
  belongs_to :course
  belongs_to :instructor
  has_many   :category_video_on_demands, dependent: :destroy
  has_many   :categories,                through: :category_video_on_demands
  has_many   :video_modules
  has_many   :videos,                    through: :video_modules

  accepts_nested_attributes_for :video_modules, reject_if: :all_blank, allow_destroy: true

  before_save :copy_course_title_and_abbreviation

  private

  def copy_course_title_and_abbreviation
    self.title        = course.title
    self.abbreviation = course.abbreviation
  end
end
