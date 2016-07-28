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
    attributes buyer: ['buyer.first_name', 'buyer.email']
  end

  def set_total
    if no_charge?
      self.total = 0
    else
      self.total = self.order_items.to_a.sum do |item|
        item.price || item.orderable.price
      end
    end
  end

  def set_paid
    # TODO: Add logic here to account for combination payment methods
    if self.payment_type == 'Cisco Learning Credits'
      self.paid = self.clc_quantity * 100
    end
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
      when 'None'
        self.status = 'Unreviewed'
        self.status_position = 1
      end
    end
  end

  def no_charge?
    self.payment_type == 'No Charge'
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

  def shipping_address
    [shipping_street, shipping_city, shipping_state, shipping_zip_code, shipping_country].reject(&:blank?).join(' ')
  end

  def confirm_with_partner
    return if referring_partner_email.blank?

    order_items.where(orderable_type: 'Event').each do |item|
      PartnerMailer.registration_made(referring_partner_email, buyer, item.orderable).deliver_now
    end
  end

  def self.items_in_range_for(seller_id, start_date, end_date)
    order_ids = Order.where(seller_id: seller_id, created_at: start_date..end_date).distinct

    OrderItem.where(order_id: order_ids, orderable_type: 'Event').distinct
  end
end
