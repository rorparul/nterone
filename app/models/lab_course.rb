# == Schema Information
#
# Table name: lab_courses
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#

class LabCourse < ActiveRecord::Base
  belongs_to :company

  has_many :lab_rentals
end
