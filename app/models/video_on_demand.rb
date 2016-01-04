class VideoOnDemand < ActiveRecord::Base
  belongs_to :platform
  belongs_to :course
  belongs_to :instructor
  has_many   :category_video_on_demands, dependent: :destroy
  has_many   :categories,                through: :category_video_on_demands
  has_many   :video_modules,             dependent: :destroy
  has_many   :videos,                    through: :video_modules

  accepts_nested_attributes_for :video_modules, reject_if: :all_blank, allow_destroy: true

  validates :categories, :title, :abbreviation, presence: true
  validates_associated :categories
end
