class Order < ActiveRecord::Base
  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"

  has_many :order_items, dependent: :destroy

  validates :buyer, presence: true
  validates_associated :buyer
  # validates :total, numericality: { greater_than_or_equal_to: 0.01 }

  accepts_nested_attributes_for :order_items

  before_create :add_up_total

  def add_up_total
    total = total_price
  end

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
