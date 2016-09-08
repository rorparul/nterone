class LabStudent < ActiveRecord::Base
  belongs_to :lab_rental

  validates :name, :email, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
end
