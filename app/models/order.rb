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

  before_save   :add_up_total, :update_status
  before_create :define_status, :define_clc_quantity

  def update_status

  end

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

# t.datetime "created_at",                                                         null: false
# t.datetime "updated_at",                                                         null: false
# t.string   "auth_code"
# t.string   "first_name"
# t.string   "last_name"
# t.string   "shipping_street"
# t.string   "shipping_city"
# t.string   "shipping_state"
# t.string   "shipping_zip_code"
# t.string   "shipping_country"
# t.string   "email"
# t.string   "clc_number"
# t.string   "billing_name"
# t.string   "billing_zip_code"
# t.decimal  "paid",                precision: 8, scale: 2, default: 0.0
# t.string   "billing_street"
# t.string   "billing_city"
# t.string   "billing_state"
# t.integer  "seller_id"
# t.integer  "buyer_id"
# t.string   "status",                                      default: "Uninvoiced"
# t.decimal  "total",               precision: 8, scale: 2, default: 0.0
# t.string   "billing_country"
# t.string   "payment_type"
# t.integer  "clc_quantity",                                default: 0
# t.string   "billing_first_name"
# t.string   "billing_last_name"
# t.string   "shipping_company"
# t.string   "billing_company"
# t.boolean  "same_addresses",                              default: false
# t.string   "shipping_first_name"
# t.string   "shipping_last_name"
# t.string   "po_number"
# t.decimal  "po_paid",             precision: 8, scale: 2, default: 0.0
# t.boolean  "verified",                                    default: false
# t.boolean  "invoiced",                                    default: false
# t.string   "invoice_number"


# = form_for order, url: order_path(order), method: :patch, remote: true do |f|
#   = f.select :status,
#              [['Uninvoiced', 'Uninvoiced'],
#               ['Unverified', 'Unverified'],
#               ['Paid in Full', 'Paid in Full'],
#               ['Verified', 'Verified']],
#               { prompt: true },
#               { class: 'form-control input-sm table-select' }
