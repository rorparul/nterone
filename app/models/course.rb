# == Schema Information
#
# Table name: courses
#
#  id                      :integer          not null, primary key
#  title                   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  platform_id             :integer
#  active                  :boolean          default(TRUE)
#  abbreviation            :string
#  intro                   :text
#  overview                :text
#  outline                 :text
#  intended_audience       :text
#  pdf                     :string
#  video_preview           :text
#  price                   :decimal(8, 2)    default(0.0)
#  slug                    :string
#  page_title              :string
#  page_description        :text
#  partner_led             :boolean          default(FALSE)
#  heading                 :string
#  satellite_viewable      :boolean          default(TRUE)
#  origin_region           :integer
#  active_regions          :text             default([]), is an Array
#  cisco_id                :string
#  archived                :boolean          default(FALSE)
#  book_cost_per_student   :decimal(, )      default(0.0)
#  featured_course_summary :text             default("")
#  exclude_from_revenue    :boolean          default(FALSE)
#
# Indexes
#
#  index_courses_on_origin_region  (origin_region)
#  index_courses_on_slug           (slug)
#

class Course < ActiveRecord::Base
  attr_accessor :temp_revenue

  extend FriendlyId

  include Imageable
  include SlugValidation
  include Regions
  include SearchCop

  mount_uploader :pdf, PdfUploader

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:abbreviation, [:abbreviation, :title], [:abbreviation, :title, :origin_region]]
  end

  belongs_to :platform
  belongs_to :lab_rental

  has_many :opportunities
  has_many :category_courses,         dependent: :destroy
  has_many :categories,               through: :category_courses
  has_many :group_items,              as: :groupable, dependent: :destroy
  has_many :course_dynamics,          dependent: :destroy
  has_many :exam_and_course_dynamics, through: :course_dynamics
  has_many :chosen_courses,           dependent: :destroy
  has_many :users,                    through: :chosen_courses
  has_many :testimonials
  has_many :events,                   dependent: :destroy
  has_many :video_on_demands,         dependent: :destroy

  search_scope :custom_search do
    attributes :id, :abbreviation, :title, :archived
  end

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :categories, :title, :abbreviation, presence: true
  validates_associated :categories

  after_initialize :set_all_regions, if: :new_record?

  before_save :format_slug
  before_save :archive_slug, if: proc { |record| record.archived? }

  scope :active, -> { where(archived: false) }

  def self.top_courses_by_revenue(region = nil, date_range_start = nil, date_range_end = nil)
    active.sort_by do |course|
      course.temp_revenue = course.revenue(region, date_range_start, date_range_end)
    end.reverse
  end
  
  def self.reset_excluded_course
    self.update_all(exclude_from_revenue: false)
  end

  def revenue(region = nil, date_range_start = nil, date_range_end = nil)
    select_opportunities = if region.nil? && date_range_start.nil? && date_range_end.nil?
      opportunities.won
    else
      if region.nil? && date_range_start.present? && date_range_end.present?
        opportunities.won.where(
          'date_closed >= ? and date_closed <= ?',
          date_range_start,
          date_range_end
        )
      elsif date_range_start.nil? && date_range_end.nil?
        opportunities.won.where(
          'origin_region = ?',
          region
        )
      else
        opportunities.won.where(
          'origin_region = ? and date_closed >= ? and date_closed <= ?',
          region,
          date_range_start,
          date_range_end
        )
      end
    end

    select_opportunities.inject(0) { |sum, opportunitie| sum += opportunitie.amount }
  end

  def active_events
    events.where(active: true).order(:start_date)
  end

  def upcoming_events
    events.where('active = ? and start_date >= ?', true, Date.today).order(:start_date)
  end

  def upcoming_public_events
    events.where('active = ? and public = ? and start_date >= ?', true, true, Date.today).order(:start_date)
  end

  def full_title
    if abbreviation.present?
      "#{abbreviation}: #{title}"
    else
      title
    end
  end

  def instructors
    User.order("onsite_daily_rate asc").all_instructors.joins(:courses).where("courses.id = ?", self.id).uniq
  end
end
