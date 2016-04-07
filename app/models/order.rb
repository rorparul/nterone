class Order < ActiveRecord::Base
  include ModelSearch

  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"

  has_many :order_items, dependent: :destroy

  attr_accessor :credit_card_number, :expiration_month, :expiration_year, :security_code

  validates :buyer, presence: true
  validates_associated :buyer
  validates_presence_of :clc_number, unless: lambda { self.payment_type != "Cisco Learning Credits" }
  # validates :total, numericality: { greater_than_or_equal_to: 0.01 }

  accepts_nested_attributes_for :order_items

  before_save   :add_up_total
  before_create :define_status, :define_clc_quantity

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
    if self.payment_type == "Credit Card"
      if self.paid == self.total
        self.status = "Paid in Full"
      end
    else
      self.status = "Unverified"
    end
  end

  def define_clc_quantity
    self.clc_quantity ||= 0
  end

  def balance
    sum = self.total - self.paid - (self.clc_quantity * 100)
    sum > 0.00 ? sum : 0.00
  end
end
