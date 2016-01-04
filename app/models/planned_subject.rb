class PlannedSubject < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  # has_many :passed_exams
  # has_many :exams,         through: :passed_exams
  validates :user, :subject, presence: true
end
