class Event < ActiveRecord::Base
  include ModelSearch
  # include SearchCop

  belongs_to :course
  belongs_to :instructor

  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items
  has_many :users,       through: :order_items

  before_destroy :ensure_not_purchased_or_in_cart

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.00 }
  validates_associated :course

  # search_scope :search do
  #   attributes :format
  #   # attributes :comment => ["comments.title", "comments.message"]
  #   # attributes :course => "courses.abbreviation"
  #   # ...
  # end
  # t.date     "start_date"
  # t.date     "end_date"
  # t.string   "format"
  # t.decimal  "price",           precision: 8, scale: 2, default: 0.0
  # t.integer  "instructor_id"
  # t.integer  "course_id"
  # t.datetime "created_at",                                              null: false
  # t.datetime "updated_at",                                              null: false
  # t.boolean  "guaranteed",                              default: false
  # t.boolean  "active",                                  default: true
  # t.time     "start_time"
  # t.time     "end_time"
  # t.string   "city"
  # t.string   "state"
  # t.string   "status"
  # t.string   "lab_source"
  # t.boolean  "public",                                  default: true
  # t.decimal  "cost_instructor", precision: 8, scale: 2, default: 0.0
  # t.decimal  "cost_lab",        precision: 8, scale: 2, default: 0.0
  # t.decimal  "cost_te",         precision: 8, scale: 2, default: 0.0
  # t.decimal  "cost_facility",   precision: 8, scale: 2, default: 0.0
  # t.decimal  "cost_books",      precision: 8, scale: 2, default: 0.0
  # t.decimal  "cost_shipping",   precision: 8, scale: 2, default: 0.0
  # t.boolean  "partner_led",                             default: false
  # t.string   "time_zone"

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
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
