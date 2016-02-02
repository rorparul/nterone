class Video < ActiveRecord::Base
  belongs_to :video_module

  has_many :watched_videos, dependent: :destroy
  has_many :users,          through: :watched_videos

  validates :title, :embed_code, presence: true

  def permit_user?(user)
    OrderItem.find_by('orderable_type = ? and orderable_id = ? and created_at >= ? and user_id = ?',
                      'VideoOnDemand',
                      video_module.video_on_demand.id,
                      Date.today - 365.day,
                      user.id)
  end
end
