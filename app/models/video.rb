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
#  origin_region   :integer
#  active_regions  :text             default([]), is an Array
#

class Video < ActiveRecord::Base
  extend FriendlyId
  include Regions

  belongs_to :video_module

  has_many :watched_videos, dependent: :destroy
  has_many :users,          through: :watched_videos
  has_many :lms_exams,      dependent: :destroy
  has_many :lms_exam_questions, through: :lms_exams

  validates :title, :embed_code, presence: true

  friendly_id :title, use: [:slugged, :finders]

  def permit_user?(user)
    video_module.video_on_demand.purchased_by?(user) || video_module.video_on_demand.assigned_to?(user)
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
