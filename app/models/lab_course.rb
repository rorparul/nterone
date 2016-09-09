class LabCourse < ActiveRecord::Base
  belongs_to :company
  
  has_many :lab_rentals
end
