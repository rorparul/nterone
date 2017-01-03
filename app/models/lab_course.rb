# == Schema Information
#
# Table name: lab_courses
#
#  id           :integer          not null, primary key
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#  description  :text
#  slug         :string
#  abbreviation :string
#

class LabCourse < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :title,
      [:title, :abbreviaton]
    ]
  end

  belongs_to :company

  has_many :lab_rentals
  has_many :lab_course_time_blocks

  validates :title, presence: true


  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end
end
