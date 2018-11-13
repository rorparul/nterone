# == Schema Information
#
# Table name: events
#
#  id                             :integer          not null, primary key
#  start_date                     :date
#  end_date                       :date
#  format                         :string
#  price                          :decimal(8, 2)    default(0.0)
#  instructor_id                  :integer
#  course_id                      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  guaranteed                     :boolean          default(FALSE)
#  active                         :boolean          default(TRUE)
#  start_time                     :time
#  end_time                       :time
#  city                           :string
#  state                          :string
#  status                         :string           default("Pending")
#  lab_source                     :string
#  public                         :boolean          default(TRUE)
#  cost_instructor                :decimal(8, 2)    default(0.0)
#  cost_lab                       :decimal(8, 2)    default(0.0)
#  cost_te                        :decimal(8, 2)    default(0.0)
#  cost_facility                  :decimal(8, 2)    default(0.0)
#  cost_books                     :decimal(8, 2)    default(0.0)
#  cost_shipping                  :decimal(8, 2)    default(0.0)
#  partner_led                    :boolean          default(FALSE)
#  time_zone                      :string
#  sent_all_webex_invite          :boolean          default(FALSE)
#  sent_all_course_material       :boolean          default(FALSE)
#  sent_all_lab_credentials       :boolean          default(FALSE)
#  should_remind                  :boolean          default(FALSE)
#  remind_period                  :integer          default(0)
#  reminder_sent                  :boolean          default(FALSE)
#  note                           :text
#  count_weekends                 :boolean          default(FALSE)
#  in_house_note                  :text
#  street                         :string
#  language                       :integer          default(0)
#  calculate_book_costs           :boolean          default(TRUE)
#  autocalculate_instructor_costs :boolean          default(TRUE)
#  resell                         :boolean          default(FALSE)
#  zipcode                        :string
#  origin_region                  :integer
#  active_regions                 :text             default([]), is an Array
#  company                        :string
#  checklist_id                   :integer
#  cost_commission                :decimal(8, 2)    default(0.0)
#  autocalculate_cost_commission  :boolean          default(TRUE)
#  do_not_send_instructor_email   :boolean          default(FALSE)
#  country_code                   :string
#  location                       :string
#  registration_url               :string
#  registration_phone             :string
#  registration_fax               :string
#  registration_email             :string
#  site_id                        :string
#  archived                       :boolean          default(FALSE)
#  book_cost_per_student          :decimal(8, 2)    default(0.0)
#  upload_id                      :string
#  approved                       :boolean          default(TRUE)
#  sales_rep_id                   :integer
#  customer_name                  :string           default("")
#  estimated_student_count        :integer          default(0)
#
# Indexes
#
#  index_events_on_checklist_id   (checklist_id)
#  index_events_on_origin_region  (origin_region)
#

class Event < ActiveRecord::Base
  default_scope { where(approved: true) }

  include SearchCop
  include Regions

  LIVE_ONLINE_FORMATS = [
    'Live Online',
    'Live Online Americas',
    'Live Online LATAM',
    'Live Online APAC',
    'Live Online EMER'
  ]

  enum language: {
    en: 0,
    es: 1
  }

  enum remind_period: {
    one_week: 0,
    two_week: 1,
    one_month: 2
  }

  belongs_to :course
  belongs_to :instructor, class_name: 'User'
  belongs_to :sales_rep, class_name: 'User'
  belongs_to :checklist

  has_many :opportunities
  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items
  has_many :users,       through: :order_items
  has_many :registrations

  has_many :checklist_items_events, class_name: "ChecklistItemsEvents"
  has_and_belongs_to_many :checklist_items

  after_initialize :assign_default_book_cost_per_student, if: proc { |model| model.new_record? }

  before_save :calculate_book_cost,       if: proc { |model| model.calculate_book_costs? }
  before_save :calculate_instructor_cost, if: proc { |model| model.autocalculate_instructor_costs? }
  before_save :calculate_cost_commission, if: proc { |model| model.autocalculate_cost_commission? }
  before_save :mark_non_public

  after_save :create_gtr_alert,        if: proc { |model| model.guaranteed_changed? && model.guaranteed? }
  after_save :destroy_gtr_alert,       if: proc { |model| model.guaranteed_changed? && model.guaranteed_was == true }
  after_save :confirm_with_instructor, if: proc { |model| model.instructor_id_changed? && model.instructor.present? }

  before_destroy :ensure_not_purchased_or_in_cart

  # NOTE: Uncomment after the new events have been uploaded without problems
  # after_destroy :destroy_gtr_alert

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  # validates :course_id, uniqueness: { scope: [:start_date, :end_date, :format] }
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }
  validates_associated :course

  after_initialize :set_all_regions, if: :new_record?

  scope :from_source,   -> (source) { joins(:orders).where(orders: { source: source }).distinct }
  scope :remind_needed, -> { where('start_date > ?', Time.now).where(should_remind: true, reminder_sent: false) }

  search_scope :custom_search do
    attributes :id, :format, :start_date, :public, :guaranteed, :street, :city, :state, :zipcode
    attributes :course => ["course.abbreviation", "course.title"]
    attributes :users => ["users.first_name", "users.last_name", "users.email"]
    attributes :instructor => ["instructor.first_name", "instructor.last_name"]
  end

  delegate :platform, to: :course

  class << self
    def upcoming_events
      where("start_date >= :start_date", { start_date: 1.week.ago.beginning_of_week })
    end

    def guaranteed_events
      where(guaranteed: true).order(:start_date)
    end

    def upcoming_public_events
      where('active = ? and public = ? and start_date >= ?', true, true, Date.today).order(:start_date)
    end

    def guaranteed_upcoming_events
      where("active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Date.today })
    end

    def in_range(start_date, end_date)
      Event.joins(:order_items)
           .where(start_date: start_date..end_date, order_items: { cart_id: nil })
           .where.not(order_items: { order_id: nil }).distinct
    end

    def with_students
      # TODO: Figure out a way to remove the double-query
      ids_with_students = joins(:order_items).where(order_items: { cart_id: nil }).distinct.pluck(:id)
      Event.where(id: ids_with_students)
    end

    def average_margin(region, date_range_start, date_range_end)
      events = if region.nil? && date_range_start.nil? && date_range_end.nil?
                 where(archived: false)
               else
                 if region.nil? && date_range_start.present? && date_range_end.present?
                   where(archived: false).where(
                     'end_date >= ? and end_date <= ?',
                     date_range_start,
                     date_range_end
                   )
                 elsif date_range_start.nil? && date_range_end.nil?
                   where(archived: false).where(
                     'events.origin_region = ?',
                     region
                   )
                 else
                   where(archived: false).where(
                     'events.origin_region = ? and end_date >= ? and end_date <= ?',
                     region,
                     date_range_start,
                     date_range_end
                   )
                 end
               end

      events_with_positive_revenue = events.reject { |event| event.revenue == 0.0 }

      total_revenue    = events_with_positive_revenue.inject(0) { |sum, event| sum += event.revenue }
      total_expenses   = events_with_positive_revenue.inject(0) { |sum, event| sum += event.total_cost }
      total_net_profit = total_revenue - total_expenses

      total_revenue == 0 ? total_net_profit : (total_net_profit / total_revenue) * 100
    end
  end

  def length
    if self.end_date && self.start_date
      range = self.start_date..self.end_date
      count = self.count_weekends ? range.count : range.select { |day| (1..5).include?(day.wday) }.count

      count > 0 ? count : 1
    end
  end

  def student_count
    OrderItem.where(orderable_id: self.id, orderable_type: "Event", cart_id: nil).count
  end

  def invoiced_amount
    orders.where(status: 'invoiced').sum(:total)
  end

  def commission_percent
    if student_count >= 10
      0.08
    else
      0.05
    end
  end

  def revenue
    order_items.where.not(order_id: nil).sum(:price)
  end

  def margin
    (net_revenue / revenue) * 100
  end

  def revenue_by(user_id)
    order_items.where.not(order_id: nil).joins(:order).where(orders: { seller_id: user_id }).sum(:price)
  end

  def total_cost
    [cost_instructor, cost_lab, cost_te, cost_facility, cost_books, cost_shipping, cost_commission].compact.sum
  end

  def net_revenue
    revenue - total_cost
  end

  def week_range
    [
      self.start_date.at_beginning_of_week.to_formatted_s(:rfc822),
      ' - ',
      self.start_date.at_end_of_week.to_formatted_s(:rfc822)
    ].join
  end

  def full_location
    if city.present? || state.present?
      "#{city}, #{state}"
    else
      Event::LIVE_ONLINE_FORMATS.include?(format) ? format : ''
    end
  end

  def event_platform
    course.try(:platform).try(:title)
  end

  def checklist_completed?
    if checklist
      (checklist.items.map(&:id) - checklist_items.map(&:id)).empty?
    else
      false
    end
  end

  def title_with_instructor_and_state
    if state.present?
      "#{instructor.full_name} [#{course.abbreviation}] [#{state}] #{instructor.instructor_employment_date}"
    else
      "#{instructor.full_name} [#{course.abbreviation}] #{instructor.instructor_employment_date }"
    end
  end

  private

  def create_gtr_alert
    EventMailer.create_gtr_alert(self).deliver_now
  end

  def destroy_gtr_alert
    EventMailer.destroy_gtr_alert(self).deliver_now
  end

  def ensure_not_purchased_or_in_cart
    if order_items.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end

  def assign_default_book_cost_per_student
    self.book_cost_per_student = course.try(:book_cost_per_student)
  end

  def calculate_book_cost
    self.cost_books = book_cost_per_student * student_count
  end

  def calculate_instructor_cost
    if instructor
      self.cost_instructor = instructor.daily_rate(self) * length
    else
      self.cost_instructor = 0.0
    end
  end

  def calculate_cost_commission
    self.cost_commission = revenue * commission_percent
  end

  def confirm_with_instructor
    InstructorMailer.confirm_class(instructor, self).deliver_now unless do_not_send_instructor_email?
  end

  def mark_non_public
    self.public = false if resell
    true
  end
end
