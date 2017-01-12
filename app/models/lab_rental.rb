# == Schema Information
#
# Table name: lab_rentals
#
#  id                :integer          not null, primary key
#  first_day         :date
#  num_of_students   :integer          default(0)
#  start_time        :time
#  instructor        :string
#  instructor_email  :string
#  instructor_phone  :string
#  notes             :text
#  location          :string
#  confirmed         :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course            :string
#  user_id           :integer
#  company_id        :integer
#  canceled          :boolean
#  lab_course_id     :integer
#  end_time          :time
#  kind              :integer
#  time_zone         :string
#  twenty_four_hours :boolean
#  last_day          :date
#  level             :string
#
# Indexes
#
#  index_lab_rentals_on_lab_course_id  (lab_course_id)
#
# Foreign Keys
#
#  fk_rails_d4d0b72fbf  (lab_course_id => lab_courses.id)
#

class LabRental < ActiveRecord::Base
	include SearchCop

	belongs_to :user
	belongs_to :company
  belongs_to :lab_course

	has_many :lab_students, dependent: :destroy

	accepts_nested_attributes_for :lab_students, reject_if: :all_blank, allow_destroy: true

	validates :company_id, :lab_course_id, :kind, presence: true
	validates_format_of :instructor_email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, unless: Proc.new { |model| model.instructor_email.blank? }

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
