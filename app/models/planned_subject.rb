# == Schema Information
#
# Table name: planned_subjects
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  subject_id     :integer
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  active         :boolean          default(TRUE)
#  read           :boolean          default(FALSE)
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class PlannedSubject < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :subject

  # has_many :passed_exams
  # has_many :exams,         through: :passed_exams
  validates :user, :subject, presence: true
end
