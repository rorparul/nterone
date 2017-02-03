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
#
# Indexes
#
#  index_order_items_on_orderable_id  (orderable_id)
#

class OrderItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  belongs_to :order
  belongs_to :orderable, polymorphic: true

  before_create :copy_current_orderable_price, unless: Proc.new {|model| model.orderable_type == "LabRental"}
  before_save   :update_status
  after_save    :update_event_status
  after_save    :calculate_event_book_cost, if: Proc.new {|model| model.cart_id.nil? }
  after_destroy :calculate_event_book_cost

  # validates :cart_id, uniqueness: { scope: [:orderable_id, :orderable_type] }
  # validates :order, presence: true
  # validates_associated :order
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
    if orderable_type == "Event"
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
    return true if orderable_type == 'VideoOnDemand' && orderable.cisco_digital_learning == true
    return false
  end

  private

  def copy_current_orderable_price
    if self.cart_id
       self.price = self.orderable.price
    end
  end

  def calculate_event_book_cost
    if orderable_type == "Event"
      event = Event.find(self.orderable_id)
      if event.calculate_book_costs?
        platform_title = event.course.platform.title
        case platform_title
        when "Cisco"
          event.cost_books = 350.00 * event.student_count
        when "VMware"
          event.cost_books = 725.00 * event.student_count
        end
        event.save
      end
    end
  end
end
