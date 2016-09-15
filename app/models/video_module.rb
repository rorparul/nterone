# == Schema Information
#
# Table name: video_modules
#
#  id                 :integer          not null, primary key
#  video_on_demand_id :integer
#  title              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  position           :integer          default(0)
#

class VideoModule < ActiveRecord::Base
  belongs_to :video_on_demand
  has_many   :videos, dependent: :destroy

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
end
