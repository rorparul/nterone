# == Schema Information
#
# Table name: videos
#
#  id              :integer          not null, primary key
#  video_module_id :integer
#  title           :string
#  url             :string
#  embed_code      :text
#  free            :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  position        :integer          default(0)
#  slug            :string
#

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
