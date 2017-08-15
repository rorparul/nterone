# == Schema Information
#
# Table name: chosen_courses
#
#  id             :integer          not null, primary key
#  course_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string
#  planned        :boolean          default(FALSE)
#  attended       :boolean          default(FALSE)
#  passed         :boolean          default(FALSE)
#  user_id        :integer
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class ChosenCourse < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :course

  validates :user, :course, presence: true
end
