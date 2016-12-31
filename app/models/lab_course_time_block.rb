# == Schema Information
#
# Table name: lab_course_time_blocks
#
#  id               :integer          not null, primary key
#  lab_course_id    :integer
#  title            :string
#  unit_size        :decimal(4, 2)    default(1.0)
#  unit_quantity    :integer
#  ratio            :integer          default(1)
#  level_individual :boolean          default(FALSE)
#  level_partner    :boolean          default(FALSE)
#  price            :decimal(8, 2)    default(0.0)
#

class LabCourseTimeBlock < ActiveRecord::Base
  belongs_to :lab_course

  validates :lab_course_id, :title, :unit_size, :unit_quantity, :ratio, presence: true

  def full_title
    "#{self.lab_course.title}: #{self.title}"
  end
end
