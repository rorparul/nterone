class Video < ActiveRecord::Base
  extend FriendlyId

  belongs_to :video_module

  has_many :watched_videos, dependent: :destroy
  has_many :users,          through: :watched_videos
  has_many :lms_exams,      dependent: :destroy
  has_many :lms_exam_questions, through: :lms_exams

  validates :title, :embed_code, presence: true

  friendly_id :title, use: [:slugged, :finders]

  def permit_user?(user)
    video_module.video_on_demand.purchased_by?(user)
  end

  def next_video
    next_video = nil

    video_module.videos.order(:position).each do |video|
      next_video = video if video.position > position
    end

    next_video
  end

  def status_for(user)
    watched_videos.where(user: user).first.try(:status)
  end
end
