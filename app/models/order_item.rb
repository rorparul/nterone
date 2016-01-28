class OrderItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  belongs_to :order
  belongs_to :orderable, polymorphic: true

  before_save :copy_current_orderable_price

  validates :cart_id, uniqueness: { scope: [:orderable_id, :orderable_type] }
  # validates :order, presence: true
  # validates_associated :order
  # validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  def paid
    sum = price - order.paid
    if sum <= 0.0
      price
    else
      sum
    end
  end

  def due
    sum = price - order.paid
    if sum <= 0.0
      0.0
    else
      sum
    end
  end

  private

  def copy_current_orderable_price
    self.price = self.orderable.price
  end
end
