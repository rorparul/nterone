class OrderItem < ActiveRecord::Base
  belongs_to :user
  # belongs_to :seller, class_name: "User"
  # belongs_to :buyer,  class_name: "User"
  belongs_to :cart
  belongs_to :order
  belongs_to :orderable, polymorphic: true
  # belongs_to :ownable,   polymorphic: true

  before_save :copy_current_orderable_price

  validates :cart_id, uniqueness: { scope: [:orderable_id, :orderable_type] }

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
