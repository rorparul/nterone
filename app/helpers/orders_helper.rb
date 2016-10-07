module OrdersHelper
  def orders_revenue_total(order_items, rep_id)
    order_items.inject(0) { |sum, item| item.revenue + sum }
  end

  def orders_commission_total(order_items)
    order_items.inject(0) { |sum, item| item.commission + sum }
  end
end
