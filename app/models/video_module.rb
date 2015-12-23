class VideoModule < ActiveRecord::Base
  belongs_to :video_on_demand
  has_many   :videos

  accepts_nested_attributes_for :videos, reject_if: :all_blank, allow_destroy: true
end
