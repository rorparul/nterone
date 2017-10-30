# == Schema Information
#
# Table name: testimonials
#
#  id             :integer          not null, primary key
#  quotation      :string
#  author         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company        :string
#  course_id      :integer
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_testimonials_on_origin_region  (origin_region)
#

class Testimonial < ActiveRecord::Base
  include Regions

  belongs_to :course

  validates :quotation, presence: true

  default_scope { where(origin_region: self.get_session_region) }
end
