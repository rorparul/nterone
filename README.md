Event.all.each do |event|
  if event.cost_instructor == nil
    event.cost_instructor = 0.0
  end
  if event.cost_lab == nil
    event.cost_lab = 0.0
  end
  if event.cost_te == nil
    event.cost_te = 0.0
  end
  if event.cost_facility == nil
    event.cost_facility = 0.0
  end  
  if event.cost_books == nil
    event.cost_books = 0.0
  end
  if event.cost_shipping == nil
    event.cost_shipping = 0.0
  end
  event.save
end

Order.all.each do |order|
  order.buyer_id = order.user_id
  order.save
end

Event.where(cost_instructor: nil).each do |event|
  if event.cost_instructor == nil
    event.update_attributes(cost_instructor: 0.0)
  end
  if event.cost_lab == nil
    event.update_attributes(cost_lab: 0.0)
  end
  if event.cost_te == nil
    event.update_attributes(cost_te: 0.0)
  end
  if event.cost_facility == nil
    event.update_attributes(cost_facility: 0.0)
  end  
  if event.cost_books == nil
    event.update_attributes(cost_books: 0.0)
  end
  if event.cost_shipping == nil
    event.update_attributes(cost_shipping: 0.0)
  end
  event.start_time = "2000-01-01 19:35:00"
  event.end_time = "2000-01-01 19:35:00"
  event.save!
end
