module OrdersHelper
  def orders_revenue_total(order_items, rep_id)
    order_items.inject(0) { |sum, item| item.revenue + sum }
  end

  def orders_commission_total(order_items)
    order_items.inject(0) { |sum, item| item.commission + sum }
  end

  def weekly_revenue(date_range, queried_events)
    parsed_date_range = date_range.split(' - ')
    start_date        = parsed_date_range.first
    end_date          = parsed_date_range.last
    events_in_range   = queried_events.where("start_date >= ? and start_date <= ?", start_date, end_date)
    events_in_range.inject(0) { |sum, event| sum + event.revenue }
  end

  def formatted_discount(discount)
    if discount.kind == 'percent'
      "#{number_with_precision(discount.value, precision: 2)}%"
    elsif discount.kind == 'nominal'
      "$#{number_with_precision(discount.value, precision: 2)}"
    end
  end
  
  def course_options(event, order_item)
    events = nil
    
    if event.present?
      events = event.course.events.joins(:course).order('courses.abbreviation')
    else
      events = Event.joins(:course).order('courses.abbreviation')
    end  
    events.collect { |event| ["#{event.course.abbreviation} (#{event.start_date} - #{event.end_date}) - #{dollar_value(event.price)} #{'- Price Difference: '+ (event.price - order_item.price).to_s}", event.id] }
  end

end
