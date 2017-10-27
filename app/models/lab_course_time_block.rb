# == Schema Information
#
# Table name: lab_course_time_blocks
#
#  id             :integer          not null, primary key
#  lab_course_id  :integer
#  unit_size      :decimal(4, 2)    default(1.0)
#  unit_quantity  :integer
#  ratio          :integer          default(1)
#  price          :decimal(8, 2)    default(0.0)
#  level          :string
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_lab_course_time_blocks_on_origin_region  (origin_region)
#

class LabCourseTimeBlock < ActiveRecord::Base
  include Regions

  belongs_to :lab_course

  validates :lab_course_id, :unit_size, :unit_quantity, :ratio, presence: true
  validates :level, inclusion: { in: %w(individual partner), message: "%{value} is not a valid level" }

  def full_title
    "#{self.lab_course.title}: #{self.title}"
  end
end
