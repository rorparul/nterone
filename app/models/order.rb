# == Schema Information
#
# Table name: orders
#
#  id                      :integer          not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  auth_code               :string
#  first_name              :string
#  last_name               :string
#  shipping_street         :string
#  shipping_city           :string
#  shipping_state          :string
#  shipping_zip_code       :string
#  shipping_country        :string
#  email                   :string
#  clc_number              :string
#  billing_name            :string
#  billing_zip_code        :string
#  paid                    :decimal(8, 2)    default(0.0)
#  billing_street          :string
#  billing_city            :string
#  billing_state           :string
#  seller_id               :integer
#  buyer_id                :integer
#  status                  :string           default("Uninvoiced")
#  total                   :decimal(8, 2)    default(0.0)
#  billing_country         :string
#  payment_type            :string
#  clc_quantity            :integer          default(0)
#  billing_first_name      :string
#  billing_last_name       :string
#  shipping_company        :string
#  billing_company         :string
#  same_addresses          :boolean          default(FALSE)
#  shipping_first_name     :string
#  shipping_last_name      :string
#  po_number               :string
#  po_paid                 :decimal(8, 2)    default(0.0)
#  verified                :boolean          default(FALSE)
#  invoiced                :boolean          default(FALSE)
#  invoice_number          :string
#  status_position         :integer
#  reviewed                :boolean          default(FALSE)
#  balance                 :decimal(8, 2)    default(0.0)
#  referring_partner_email :string
#  gilmore_order_number    :string
#  gilmore_invoice         :string
#  royalty_id              :string
#  closed_date             :date
#  source                  :integer          default(0)
#  other_source            :string
#  discount_id             :integer
#
# Indexes
#
#  index_orders_on_buyer_id   (buyer_id)
#  index_orders_on_seller_id  (seller_id)
#

class Order < ActiveRecord::Base
  include SearchCop
  extend Enumerize

  enum source: {
    cisco_locator: 1,
    cisco_road_show: 2,
    cisco_live: 3,
    cisco_gsx: 4,
    rain_king: 5,
    telemarketing: 6,
    google_ads: 7,
    vmware_world: 8,
    demand_generation: 9,
    other: 10
  }

  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"
  belongs_to :discount
  belongs_to :opportunity

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

  # def self.sources
  #   Order.source.values.map!{ |source| source.humanize }
  # end

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

  def confirm_with_rep
    return unless seller

    order_items.where(orderable_type: 'Event').each do |item|
      RegistrationMailer.registration_made(seller, buyer, item.orderable).deliver_now
    end
  end

  def self.items_in_range_for(seller_id, start_date, end_date)
    order_ids   = Order.where(seller_id: seller_id).distinct
    order_items = OrderItem.where(order_id: order_ids, orderable_type: 'Event').distinct.select do |order_item|
      (start_date..end_date).include?(order_item.orderable.start_date)
    end

    order_items.sort_by do |order_item|
      [order_item.orderable.start_date, order_item.orderable.course.abbreviation]
    end
  end
end
