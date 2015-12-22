class VideoModule < ActiveRecord::Base
  belongs_to :video_on_demand
  has_many   :videos
end
