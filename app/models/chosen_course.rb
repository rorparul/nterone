# == Schema Information
#
# Table name: chosen_courses
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string
#  planned    :boolean          default(FALSE)
#  attended   :boolean          default(FALSE)
#  passed     :boolean          default(FALSE)
#  user_id    :integer
#

class ChosenCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user, :course, presence: true
end
