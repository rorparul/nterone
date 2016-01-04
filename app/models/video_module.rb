class VideoModule < ActiveRecord::Base
  belongs_to :video_on_demand
  has_many   :videos, dependent: :destroy

  accepts_nested_attributes_for :videos, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
end
