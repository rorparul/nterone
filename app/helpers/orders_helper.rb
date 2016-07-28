module OrdersHelper
  def orders_revenue_total(order_items)
    order_items.inject(0) do |items_sum, item|
      item.orderable_type == 'Event' ? item.orderable.revenue + items_sum : items_sum
    end
  end

  def orders_commission_total(order_items)
    order_items.inject(0) do |items_sum, item|
      item.orderable_type == 'Event' ? item.orderable.commission + items_sum : items_sum
    end
  end
end
