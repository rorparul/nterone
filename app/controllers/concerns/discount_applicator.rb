module DiscountApplicator
  extend ActiveSupport::Concern

  private

  def discounted_total(cart, discount)
    order_items                      = cart.order_items
    order_items_total_price          = cart.total_price
    eligible_order_items             = order_items.select { |order_item| eligible_order_item?(order_item, discount) }
    eligible_order_items_total_price = eligible_order_items.to_a.sum { |order_item| order_item.price }

    p eligible_order_items
    p eligible_order_items_total_price

    order_items_total_price - applicable_nominal_discount(eligible_order_items_total_price, discount)
  end

  def applicable_nominal_discount(price, discount)
    if discount.kind == 'percent'
      price * (discount.value / 100.00)
    elsif discount.kind == 'nominal'
      if price <= discount.value
        price
      else
        discount.value
      end
    end
  end

  def set_filters(hash)
    hash.delete('id')
    hash.delete('discount_id')
    hash.delete('event')
    hash.delete('vod')
    hash
  end

  def eligible_order_item?(order_item, discount)
    if discount.discount_filter.event? && discount.discount_filter.vod?
      orderable = order_item.orderable
      if orderable.class == Event
        if discount.discount_filter.event_guaranteed
          discount.discount_filter.event_guaranteed == orderable.guaranteed
        else
          true
        end
      end

      if orderable.class == VideoOnDemand
        true
      end
    elsif discount.discount_filter.event.blank? && discount.discount_filter.vod.blank?
      true
    else
      orderable = order_item.orderable

      if discount.discount_filter.event?
        return orderable.class == Event
      end

      if discount.discount_filter.vod?
        return orderable.class == VideoOnDemand
      end
    end
  end
end
