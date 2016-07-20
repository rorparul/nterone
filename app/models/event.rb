class Event < ActiveRecord::Base
  include SearchCop

  enum remind_period: {
    one_week: 0,
    two_week: 1,
    one_month: 2
  }

  belongs_to :course
  belongs_to :instructor

  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items
  has_many :users,       through: :order_items

  # before_save    :update_status
  before_destroy :ensure_not_purchased_or_in_cart

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }
  validates_associated :course

  scope :remind_needed, -> { where('start_date > ?', Time.now).where(should_remind: true, reminder_sent: false) }

  search_scope :custom_search do
    attributes :format, :start_date, :public, :guaranteed
    attributes :course => ["course.abbreviation", "course.title"]
    attributes :users => ["users.first_name", "users.last_name", "users.email"]
    attributes :instructor => ["instructor.first_name", "instructor.last_name"]
  end

  def self.upcoming_events
    where("start_date >= :start_date", {start_date: Date.today})
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

  def length
    if self.end_date && self.start_date
      count = (self.start_date..self.end_date).select { |day| (1..5).include?(day.wday) }.count
      count > 0 ? count : 1
    end
  end

  def self.with_students
    joins(:order_items).where(order_items: { cart_id: nil }).distinct
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
    invoiced_amount * commission_percent
  end

  def revenue
    order_items.where.not(order_id: nil).sum(:price)
  end

  def total_cost
    cost_instructor + cost_lab + cost_te + cost_facility + cost_books + cost_shipping + commission
  end

  def net_revenue
    revenue - total_cost
  end

  def start_week
    self.start_date.at_beginning_of_week.strftime("%-d %B %Y")
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
end
