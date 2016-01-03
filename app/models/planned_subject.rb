class PlannedSubject < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject

  # has_many :chosen_courses
  # has_many :courses,       through: :chosen_courses
  has_many :passed_exams
  has_many :exams,         through: :passed_exams

  # def planned_course?(course)
  #   self.chosen_courses.where(course_id: course.id, planned: true).any?
  # end
  #
  # def attended_course?(course)
  #   self.chosen_courses.where(course_id: course.id, attended: true).any?
  # end
end
