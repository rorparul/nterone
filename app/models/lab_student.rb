# == Schema Information
#
# Table name: lab_students
#
#  id            :integer          not null, primary key
#  lab_rental_id :integer
#  name          :string
#  email         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  origin_region :integer
#

class LabStudent < ActiveRecord::Base
  include Regions

  belongs_to :lab_rental

  validates :name, :email, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
end
