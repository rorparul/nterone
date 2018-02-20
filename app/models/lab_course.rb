# == Schema Information
#
# Table name: lab_courses
#
#  id               :integer          not null, primary key
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer
#  description      :text
#  slug             :string
#  abbreviation     :string
#  card_description :text
#  level            :string           default("both")
#  pods_individual  :integer          default(0)
#  pods_partner     :integer          default(0)
#  origin_region    :integer
#  active_regions   :text             default([]), is an Array
#
# Indexes
#
#  index_lab_courses_on_origin_region  (origin_region)
#

class LabCourse < ActiveRecord::Base
  extend FriendlyId

  include Imageable
  include Regions

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :title,
      [:title, :abbreviation],
      [:title, :abbreviation, :origin_region]
    ]
  end

  belongs_to :company

  has_many :lab_rentals
  has_many :lab_course_time_blocks

  has_one :topology
  accepts_nested_attributes_for :topology

  has_one  :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image

  validates :title, presence: true
  validates :pods_individual, :pods_partner, numericality: { greater_than_or_equal_to: 0 }

  def available_to_individual?
    pods_individual != nil && pods_individual > 0 && lab_course_time_blocks.any?
  end

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end
end
