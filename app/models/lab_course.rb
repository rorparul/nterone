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
#

class LabCourse < ActiveRecord::Base
  extend FriendlyId

  include Imageable

  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :title,
      [:title, :abbreviation]
    ]
  end

  belongs_to :company

  has_many :lab_rentals
  has_many :lab_course_time_blocks

  has_one  :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image

  validates :title, presence: true

  def available?
    lab_course_time_blocks.any?
  end

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end
end
