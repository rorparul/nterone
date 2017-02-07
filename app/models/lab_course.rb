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
#

class LabCourse < ActiveRecord::Base
  extend FriendlyId

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

  validates :title, presence: true
  validates :pods_individual, :pods_partner, numericality: { greater_than_or_equal_to: 0 }

  def available_to_individual?
    pods_individual > 0 && lab_course_time_blocks.any?
  end

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end
end
