# == Schema Information
#
# Table name: chosen_courses
#
#  id                               :integer          not null, primary key
#  course_id                        :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  status                           :string
#  planned                          :boolean          default(FALSE)
#  attended                         :boolean          default(FALSE)
#  passed                           :boolean          default(FALSE)
#  user_id                          :integer
#  origin_region                    :integer
#  active_regions                   :text             default([]), is an Array
#  audit_complete                   :boolean          default(FALSE)
#  completed_all_labs               :boolean          default(FALSE)
#  met_with_course_director         :boolean          default(FALSE)
#  audit_complete_by_user           :string
#  completed_all_labs_by_user       :string
#  met_with_course_director_by      :string
#  audit_complete_by_date           :date
#  completed_all_labs_by_date       :date
#  met_with_course_director_by_date :date
#
# Indexes
#
#  index_chosen_courses_on_origin_region  (origin_region)
#

class ChosenCourse < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :course

  validates :user, :course, presence: true
end
