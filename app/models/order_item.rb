class OrderItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :cart
  belongs_to :order
  belongs_to :orderable, polymorphic: true

  before_save :copy_current_orderable_price, :update_status
  after_save  :update_event_status

  # validates :cart_id, uniqueness: { scope: [:orderable_id, :orderable_type] }
  # validates :order, presence: true
  # validates_associated :order
  # validates :price, numericality: { greater_than_or_equal_to: 0.01 }

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
      if self.orderable.order_items.all? { |order_item| order_item.status == "complete" }
        orderable.update_attributes(status: "Confirmed")
      else
        orderable.update_attributes(status: "Pending")
      end
    end
  end

  private

  def copy_current_orderable_price
    self.price ||= self.orderable.price
  end
end
