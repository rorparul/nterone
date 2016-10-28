# == Schema Information
#
# Table name: carts
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cart < ActiveRecord::Base
  include SearchCop

  has_many :order_items, dependent: :destroy

  # search_scope :search_with_items do
  #   attributes :id, :created_at, :updated_at
  #   attributes :order_items => ["order_items.orderable_type", "order_items.price"]
  # end
  #
  # search_scope :search_without_items do
  #   attributes :id, :created_at, :updated_at
  # end

  def reset
    self.order_items.update_all(cart_id: nil)
  end

  def total_price
    order_items.to_a.sum { |item| item.price }
  end

  def total_event_price
    order_items.to_a.sum do |item|
      if item.orderable_type == "Event"
        item.price
      else
        0.00
      end
    end
  end

  def total_vod_price
    order_items.to_a.sum do |item|
      if item.orderable_type == "VideoOnDemand"
        item.price
      else
        0.00
      end
    end
  end

  def total_price_after_credits(credits)
    total_events_price = total_event_price - (credits.to_i * 100)
    if total_events_price < 0.00
      0.00 + total_vod_price
    else
      total_events_price + total_vod_price
    end
  end

  def credits_required_for_total_applicable_for_credits
    (total_applicable_for_credits / 100).ceil
  end

  def total_not_applicable_for_credits
    total_price - total_applicable_for_credits
  end

  def any_not_applicable_for_credits?
    total_not_applicable_for_credits > 0
  end

  def total_applicable_for_credits
    order_items.inject(BigDecimal.new(0)) do |total, order_item|
      if order_item.orderable_type == 'Event' && order_item.orderable.course.platform.title == "Cisco"
        total + order_item.price
      else
        total + BigDecimal.new(0)
      end
    end
  end
end
