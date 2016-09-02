class LabRental < ActiveRecord::Base
	include SearchCop

	belongs_to :user
	belongs_to :company
  belongs_to :lab_course

	has_many :lab_students, dependent: :destroy

	accepts_nested_attributes_for :lab_students, reject_if: :all_blank, allow_destroy: true

	validates :company_id, :lab_course_id, presence: true

	after_save :count_students, if: Proc.new { |model| model.kind == 2 }

	search_scope :custom_search do
    attributes :course, :instructor, :instructor_email, :location
    attributes :company => ["company.title"]
  end

	private

	def count_students
		self.update_column(:num_of_students, self.lab_students.count)
	end
end
