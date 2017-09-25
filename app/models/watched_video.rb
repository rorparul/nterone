# == Schema Information
#
# Table name: watched_videos
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  video_id       :integer
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_watched_videos_on_origin_region  (origin_region)
#

class WatchedVideo < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :video
end
