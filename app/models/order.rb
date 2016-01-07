class Order < ActiveRecord::Base
  belongs_to :user

  has_many :order_items, dependent: :destroy

  validates :user, presence: true
  validates_associated :user

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      item.cart_id = nil
      order_items << item
    end
  end

  def total_price
    order_items.to_a.sum { |item| item.price }
  end
end
