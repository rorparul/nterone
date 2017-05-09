# == Schema Information
#
# Table name: testimonials
#
#  id            :integer          not null, primary key
#  quotation     :string
#  author        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  company       :string
#  course_id     :integer
#  origin_region :integer
#

class Testimonial < ActiveRecord::Base
  include Regions

  belongs_to :course

  validates :quotation, presence: true
end
