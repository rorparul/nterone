class LabRental < ActiveRecord::Base
	include SearchCop

	belongs_to :user
	belongs_to :company

  has_one :lab_course

	validates :company_id, presence: true

	search_scope :custom_search do
    attributes :course, :instructor, :instructor_email, :location
    attributes :company => ["company.title"]
  end
end
