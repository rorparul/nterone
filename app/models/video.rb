class Video < ActiveRecord::Base
  extend FriendlyId
  
  belongs_to :video_module

  has_many :watched_videos, dependent: :destroy
  has_many :users,          through: :watched_videos
  has_many :lms_exams
  has_many :lms_exam_questions, through: :lms_exams

  validates :title, :embed_code, presence: true

  friendly_id :title, use: [:slugged, :finders]

  def permit_user?(user)
    OrderItem.find_by('orderable_type = ? and orderable_id = ? and created_at >= ? and user_id = ?',
                      'VideoOnDemand',
                      video_module.video_on_demand.id,
                      Date.today - 365.day,
                      user.id)
  end

  def next_video
    next_video = nil

    video_module.videos.order(:position).each do |video|
      next_video = video if video.position > position
    end

    next_video
  end
end
