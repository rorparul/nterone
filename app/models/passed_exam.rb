# == Schema Information
#
# Table name: passed_exams
#
#  id                 :integer          not null, primary key
#  planned_subject_id :integer
#  exam_id            :integer
#  passed             :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#

class PassedExam < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam
end
