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
#  confirmed         :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course            :string
#  user_id           :integer
#  company_id        :integer
#  canceled          :boolean
#  end_time          :time
#  lab_course_id     :integer
#  kind              :integer
#  time_zone         :string
#  twenty_four_hours :boolean          default(FALSE)
#  last_day          :date
#  level             :string
#  origin_region     :integer
#  active_regions    :text             default([]), is an Array
#  setup_by          :integer
#  tested_by         :integer
#  number_of_pods    :integer
#  plus_instructor   :boolean          default(FALSE)
#  price             :decimal(8, 2)    default(0.0)
#  po_number         :integer
#  entered_into_crm  :boolean          default(FALSE)
#  invoice_number    :string
#  payment_received  :boolean          default(FALSE)
#  poc               :string
#  terms             :string
#  instructor_id     :integer
#
# Indexes
#
#  index_lab_rentals_on_lab_course_id  (lab_course_id)
#  index_lab_rentals_on_origin_region  (origin_region)
#
# Foreign Keys
#
#  fk_rails_...  (lab_course_id => lab_courses.id)
#

class LabRental < ActiveRecord::Base
	include SearchCop
include Regions

	belongs_to :user
	belongs_to :company
  belongs_to :lab_course

	has_many :lab_students, dependent: :destroy

	accepts_nested_attributes_for :lab_students, reject_if: :all_blank, allow_destroy: true

	validates :lab_course_id, presence: true
	validates :level, inclusion: { in: %w(individual partner), message: "%{value} is not a valid level" }
	validates :company_id, :kind, presence: true, if: Proc.new {|model| model.level == "partner"}
	validates_format_of :instructor_email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/, if: Proc.new { |model| !(model.instructor_email.blank?) && model.level == "partner"}

	after_save :count_students, if: Proc.new { |model| model.kind == 2 && model.level == "partner" }

  belongs_to :setup_by_user, foreign_key: :setup_by, class_name: "User"
  belongs_to :tested_by_user, foreign_key: :tested_by, class_name: "User"

	search_scope :custom_search do
    attributes :course, :instructor, :instructor_email, :location
    attributes :company => ["company.title"]
  end

	private

	def count_students
		self.update_column(:num_of_students, self.lab_students.count)
	end
end
