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
#  should_remind                  :boolean          default(TRUE)
#  remind_period                  :integer          default(0)
#  reminder_sent                  :boolean          default(FALSE)
#  note                           :text
#  count_weekends                 :boolean          default(FALSE)
#  in_house_note                  :text
#  language                       :integer          default(0)
#  street                         :string
#  calculate_book_costs           :boolean          default(TRUE)
#  autocalculate_instructor_costs :boolean          default(TRUE)
#

class Event < ActiveRecord::Base
  include SearchCop

  enum language: { en: 0, es: 1 }

  enum remind_period: {
    one_week: 0,
    two_week: 1,
    one_month: 2
  }

  belongs_to :course
  belongs_to :instructor, class_name: 'User'

  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items
  has_many :users,       through: :order_items
  has_many :registrations

  # before_save    :update_status
  before_save :calculate_book_cost,       if: Proc.new { |model| model.calculate_book_costs? }
  before_save :calculate_instructor_cost, if: Proc.new { |model| model.autocalculate_instructor_costs? }
  before_destroy :ensure_not_purchased_or_in_cart

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }
  validates_associated :course

  scope :remind_needed, -> { where('start_date > ?', Time.now).where(should_remind: true, reminder_sent: false) }
  scope :from_source, ->(source) { joins(:orders).where(orders: { source: source }).distinct }


  search_scope :custom_search do
    attributes :id, :format, :start_date, :public, :guaranteed
    attributes :course => ["course.abbreviation", "course.title"]
    attributes :users => ["users.first_name", "users.last_name", "users.email"]
    attributes :instructor => ["instructor.first_name", "instructor.last_name"]
  end

  def self.upcoming_events
    where("start_date >= :start_date", { start_date: Date.today })
  end

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
  end

  def self.upcoming_public_events
    where('active = ? and public = ? and start_date >= ?', true, true, Date.today).order(:start_date)
  end

  def self.guaranteed_upcoming_events
    where("active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Date.today })
  end

  def self.in_range(start_date, end_date)
    Event.joins(:order_items)
      .where(start_date: start_date..end_date, order_items: { cart_id: nil })
      .where.not(order_items: { order_id: nil }).distinct
  end

  def length
    if self.end_date && self.start_date
      range = self.start_date..self.end_date
      count = self.count_weekends ? range.count : range.select { |day| (1..5).include?(day.wday) }.count

      count > 0 ? count : 1
    end
  end

  def self.with_students
    # TODO: Figure out a way to remove the double-query
    ids_with_students = joins(:order_items).where(order_items: { cart_id: nil }).distinct.pluck(:id)
    Event.where(id: ids_with_students)
  end

  def student_count
    users.count
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

  def commission
    revenue * commission_percent
  end

  def revenue
    order_items.where.not(order_id: nil).sum(:price)
  end

  def revenue_by(user_id)
    order_items.where.not(order_id: nil).joins(:order).where(orders: { seller_id: user_id}).sum(:price)
  end

  def total_cost
    cost_instructor + cost_lab + cost_te + cost_facility + cost_books + cost_shipping + commission
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
      format == 'Live Online' ? 'Webex' : ''
    end
  end

  private

  def ensure_not_purchased_or_in_cart
    if users.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end

  def calculate_book_cost
    platform_title = course.platform.title
    case platform_title
    when "Cisco"
      cost = 350.00 * student_count
    when "VMware"
      cost = 725.00 * student_count
    end
    self.update_column(:cost_books, cost)
  end

  def calculate_instructor_cost
    if instructor
      self.cost_instructor = instructor.daily_rate * length
    else
      self.cost_instructor = 0.0
    end
  end
end
