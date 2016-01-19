class Event < ActiveRecord::Base
  belongs_to :course
  belongs_to :instructor

  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items
  has_many :users,       through: :order_items

  before_destroy :ensure_not_purchased_or_in_cart

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_associated :course

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
  end

  def self.guaranteed_upcoming_events
    where("active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Date.today })
  end

  def length
    if self.end_date && self.start_date
      (self.end_date - self.start_date).to_i + 1
    end
  end

  def student_count
    self.users.count
  end

  def revenue
    order_items.where.not(order_id: nil).sum(:price)
  end

  def total_cost
    cost_instructor + cost_lab + cost_te + cost_facility + cost_books + cost_shipping
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
