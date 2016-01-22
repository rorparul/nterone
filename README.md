<!-- Event.all.each do |event|
  event.cost_instructor = 0.0
  event.cost_lab = 0.0
  event.cost_te = 0.0
  event.cost_facility = 0.0
  event.cost_books = 0.0
  event.cost_shipping = 0.0
  event.save
end -->

Order.all.each do |order|
  order.buyer_id = order.user_id
  order.save
end
