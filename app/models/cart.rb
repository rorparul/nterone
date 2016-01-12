class Cart < ActiveRecord::Base
  has_many :order_items, dependent: :destroy

  def total_price
    order_items.to_a.sum { |item| item.price }
  end

  def total_event_price
    order_items.to_a.sum do |item|
      if item.orderable_type == "Event"
        item.price
      else
        0
      end
    end
  end

  def total_vod_price
    order_items.to_a.sum do |item|
      if item.orderable_type == "VideoOnDemand"
        item.price
      else
        0
      end
    end
  end

  def total_price_after_credits(credits)
    total_events_price = total_event_price - credits
    if total_events_price < 0
      0 + total_vod_price
    else
      total_events_price + total_vod_price
    end
  end
end
