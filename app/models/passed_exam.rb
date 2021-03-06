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
#  origin_region      :integer
#  active_regions     :text             default([]), is an Array
#
# Indexes
#
#  index_passed_exams_on_origin_region  (origin_region)
#

class PassedExam < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :exam
end
