class VideoOnDemand < ActiveRecord::Base
  belongs_to :course
  belongs_to :instructor
  has_many   :video_modules
end
