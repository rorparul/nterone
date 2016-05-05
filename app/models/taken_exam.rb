class TakenExam < ActiveRecord::Base
	belongs_to :user
  belongs_to :lms_exam

  validates_uniqueness_of :user, :scope => :lms_exam
end
