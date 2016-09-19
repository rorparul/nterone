# == Schema Information
#
# Table name: watched_videos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  video_id   :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WatchedVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
end
