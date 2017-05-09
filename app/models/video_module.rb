# == Schema Information
#
# Table name: video_modules
#
#  id                     :integer          not null, primary key
#  video_on_demand_id     :integer
#  title                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  position               :integer          default(0)
#  cisco_digital_learning :boolean          default(FALSE)
#  cdl_course_code        :string
#  origin_region          :integer
#

class VideoModule < ActiveRecord::Base
  include Regions

  belongs_to :video_on_demand
  has_many   :videos, dependent: :destroy

  has_many :lms_exams

  accepts_nested_attributes_for :videos, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true

  def watched_count(user)
    count = 0
    if user
      user_videos = user.videos
      videos.each do |video|
        count += 1 if user_videos.include?(video)
      end
    end
    count
  end

  def exams_count
    self.lms_exams.count
  end

  def completed_exams_count_for(user)
    self.lms_exams.inject(0) do |sum, quiz|
      quiz.completed_by?(user) ? sum + 1 : sum
    end
  end
end
