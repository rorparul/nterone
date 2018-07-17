# == Schema Information
#
# Table name: employments
#
#  id              :integer          not null, primary key
#  string          :string
#  employment_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  start_time      :time
#  end_time        :time
#  start_date      :date
#  end_date        :date
#  instructor_id   :integer

class Employment < ActiveRecord::Base
  validates :start_date, :start_time , :end_date, :end_time ,:employment_type,:instructor_id, presence: :true
  belongs_to :instructor,  class_name: "User", foreign_key: "instructor_id" 
end
