class Order < ActiveRecord::Base
  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"

  has_many :order_items, dependent: :destroy

  validates :buyer, presence: true
  validates_associated :buyer
  # validates :total, numericality: { greater_than_or_equal_to: 0.01 }

  accepts_nested_attributes_for :order_items

  before_save :define_clc_quantity, :add_up_total, :define_status

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      item.cart_id = nil
      self.order_items << item
    end
  end

  def add_up_total
    self.total = self.total_price
  end

  def total_price
    self.order_items.to_a.sum { |item| item.price }
  end

  def define_status
    if self.paid == self.total
      self.status = "Paid in Full"
    end
  end

  # TODO: Figure out why the default DB option wasn't working
  def define_clc_quantity
    # if self.clc_quantity == '' || self.clc_quantity == nil
    self.clc_quantity ||= 0
    # end
  end

  def balance
    (self.total - self.paid - (self.clc_quantity * 100)).abs
  end
end
