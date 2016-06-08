class Order < ActiveRecord::Base
  include SearchCop

  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"

  has_many :order_items, dependent: :destroy

  attr_accessor :credit_card_number, :expiration_month, :expiration_year, :security_code

  validates :buyer, presence: true
  validates_associated :buyer
  validates_presence_of :clc_number, unless: lambda { self.payment_type != "Cisco Learning Credits" }
  # validates :total, numericality: { greater_than_or_equal_to: 0.01 }

  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  before_save   :set_total, :set_paid, :set_balance, :set_status
  before_create :define_clc_quantity

  search_scope :custom_search do
    # attributes :buyer => ["buyer.first_name", "buyer.last_name", "buyer.email"]
  end

  def set_total
    # TODO: Figure out a way to derive the price f the order_items
    self.total = self.order_items.to_a.sum do |item|
      item.price || item.orderable.price
    end
  end

  def set_paid
  # TODO: Add logic here to account for combination payment methods
  end

  def set_balance
    self.balance = self.total - self.paid
  end

  def set_status
    if self.total == 0
      self.status = "No Charge"
      self.status_position = 3
    else
      case self.payment_type
      when "Credit Card"
        if self.paid == self.total
          self.status = "Paid in Full"
          self.status_position = 3
        elsif self.paid == 0
          self.status = "Not Charged"
          self.status_position = 1
        else
          self.status = "Paid in Partial"
          self.status_position = 2
        end
      when "Cisco Learning Credits"
        if self.verified
          self.status = "Verified SO"
          self.status_position = 3
        else
          self.status = "Unverified SO"
          self.status_position = 1
        end
      when "Purchase Order"
        if self.invoice_number.blank?
          self.status = "Uninvoiced"
          self.status_position = 1
        else
          if self.po_number.present? && self.po_paid == self.total
            self.status = "Paid in Full"
            self.status_position = 3
          else
            self.status = "Invoiced"
            self.status_position = 2
          end
        end
      when "Bundled"
        self.status = "Bundled"
        self.status_position = 3
      when "No Charge"
        self.status = "No Charge"
        self.status_position = 3
      end
    end
  end

  def add_order_items_from_cart(cart)
    cart.order_items.each do |item|
      item.cart_id = nil
      self.order_items << item
    end
  end

  def define_clc_quantity
    self.clc_quantity ||= 0
  end
end
