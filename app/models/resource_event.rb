# == Schema Information
#
# Table name: resource_events
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
#

class ResourceEvent < ActiveRecord::Base
  validates :start_date, :start_time , :end_date, :end_time ,:employment_type,:instructor_id, presence: :true
  belongs_to :instructor,  class_name: "User", foreign_key: "instructor_id" 


  def instructor_full_name_and_type
    "#{instructor.try(:full_name)} [#{self.employment_type}]"
  end  
end
