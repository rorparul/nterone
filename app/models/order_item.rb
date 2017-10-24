# == Schema Information
#
# Table name: order_items
#
#  id                   :integer          not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  orderable_id         :integer
#  orderable_type       :string
#  cart_id              :integer
#  price                :decimal(8, 2)    default(0.0)
#  order_id             :integer
#  user_id              :integer
#  sent_webex_invite    :boolean          default(FALSE)
#  sent_course_material :boolean          default(FALSE)
#  sent_lab_credentials :boolean          default(FALSE)
#  status               :string
#  note                 :text
#  origin_region        :integer
#  active_regions       :text             default([]), is an Array
#
# Indexes
#
#  index_order_items_on_orderable_id  (orderable_id)
#

class OrderItem < ActiveRecord::Base
  include Regions

  belongs_to :user
  belongs_to :cart
  belongs_to :order
  belongs_to :orderable, polymorphic: true, autosave: true

  before_create :copy_current_orderable_price, unless: proc { |model| model.orderable_type == "LabRental" }

  before_save :update_status
  # before_save :create_opportunity, if: :opportunity_is_createable?

  after_save :update_event_status

  validates :price, numericality: { greater_than_or_equal_to: 0.00 }

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

  def fullfilled?
    sent_webex_invite && sent_course_material && sent_lab_credentials
  end

  def update_status
    if fullfilled?
      self.status = "complete"
    else
      self.status = "pending"
    end
  end

  def update_event_status
    if orderable_type == "Event" && self.orderable.present?
      if self.orderable.order_items.where(cart_id: nil).all? { |order_item| order_item.status == "complete" }
        orderable.update_attributes(status: "Confirmed")
      else
        orderable.update_attributes(status: "Pending")
      end
    end
  end

  def revenue
    self.price
  end

  def commission
    self.price * self.orderable.commission_percent
  end

  def clc_applicable
    return true if orderable_type == 'Event' && orderable.course.platform.title == 'Cisco'
    return true if cisco_private_label_product?
    return false
  end

  def cisco_private_label_product?
    orderable_type == 'VideoOnDemand' && orderable.cisco_course_product_code.present?
  end

  private

  def copy_current_orderable_price
    if self.cart_id
       self.price = self.orderable.try(:price)
    end
  end

  def opportunity_is_createable?
    return false if order.nil?

    existing_opportunity = Opportunity.find_by(
      employee_id: order.seller_id,
      customer_id: order.buyer_id,
      event_id:    orderable_id
    )

    [
      order.present?,
      order.seller.present?,
      orderable.class == Event,
      existing_opportunity.nil?
    ].all?
  end

  def create_opportunity
    opportunity = Opportunity.new(
      employee_id: order.seller_id,
      customer_id: order.buyer_id,
      # account_id: ,
      # title: ,
      stage: 100,
      amount: price,
      # kind: ,
      # reason_for_loss: ,
      # waiting: ,
      # payment_kind: ,
      # billing_street: ,
      # billing_city: ,
      # billing_state: ,
      # billing_zip_code: ,
      # partner_id: ,
      date_closed: Date.today,
      course_id: orderable.try(:course).id,
      event_id: orderable_id,
      # email_optional: ,
      notes: note
    )

    Opportunity.skip_callback(:save, :after, :create_order)
    Opportunity.skip_callback(:save, :after, :update_order)
    Opportunity.skip_callback(:save, :after, :destroy_order)

    opportunity.save

    order.update_columns(opportunity_id: opportunity.id)
  end
end
