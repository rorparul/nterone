class Video < ActiveRecord::Base
  belongs_to :video_module

  has_many :watched_videos, dependent: :destroy
  has_many :users,          through: :watched_videos

  validates :title, :embed_code, presence: true

  def permit_user?(user)
    free || video_module.video_on_demand.users.include?(user)
  end
end
