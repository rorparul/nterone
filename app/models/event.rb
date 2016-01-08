class Event < ActiveRecord::Base
  belongs_to :course
  belongs_to :instructor

  has_many :order_items, as: :orderable
  has_many :orders,      through: :order_items

  before_destroy :ensure_not_referenced_by_any_order_item

  validates :course, :price, :format, :start_date, :end_date, :start_time, :end_time, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
  validates_associated :course

  def self.guaranteed_events
    where(guaranteed: true).order(:start_date)
  end

  def self.guaranteed_upcoming_events
    where("active = :active and guaranteed = :guaranteed and start_date >= :start_date", { active: true, guaranteed: true, start_date: Time.now })
  end

  def length
    if self.end_date && self.start_date
      (self.end_date - self.start_date).to_i + 1
    end
  end

  private

  def ensure_not_referenced_by_any_order_item
    if order_items.empty?
      return true
    else
      errors.add(:base, 'Order Items present')
      return false
    end
  end
end
