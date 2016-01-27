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

<!-- Subject.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.gsub(':', '')
    course.save
  end
end

Course.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.gsub(':', '')
    course.save
  end
end

VideoOnDemand.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.gsub(':', '')
    course.save
  end
end -->

Subject.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.rstrip
    course.save
  end
end

Course.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.rstrip
    course.save
  end
end

VideoOnDemand.all.each do |course|
  if course.abbreviation
    course.abbreviation = course.abbreviation.rstrip
    course.save
  end
end
