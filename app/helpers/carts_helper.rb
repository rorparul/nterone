module CartsHelper
  include CurrentCart

  def credits_calculator(cart)
    applicable = cart.order_items.inject(BigDecimal.new(0)) do |total, order_item|
      if order_item.orderable_type == 'Event' && order_item.orderable.course.platform.title == "Cisco"
        total + order_item.price
      else
        total + BigDecimal.new(0)
      end
    end
    (applicable / 100).ceil
  end

  def cc_years
    yrs = []
    year_today = Date.today.strftime("%y").to_i
    year_today.upto(year_today+10).each do |y| yrs << y.to_s;end
    return yrs
  end

  def cc_months
    ['01','02','03','04','05','06','07','08','09','10','11','12']
  end

  def link_to_cart(item, link=false)
    carted_items    = @cart.order_items.map(&:orderable)
    purchased_items = user_signed_in? ? current_user.purchased_items(orderables: true) : []
    messages        = if link
                        ['Item in cart', 'Purchased', 'Get link']
                      elsif item.class == Event
                        ['Registration in cart', 'Registered', 'Register']
                      elsif item.class == VideoOnDemand
                        ['Subscription in cart', 'Subscribed', 'Subscribe']
                      else
                        ['Item in cart', 'Purchased', 'Add to cart']
                      end

    if carted_items.include?(item)
      ("<button class='btn-link' type='submit' disabled='true'>" +
        "<span class='text-muted'>#{messages[0]}</span>" +
      "</button>").html_safe
    elsif purchased_items.include?(item)
      ("<button class='btn-link' type='submit' disabled='true'>" +
        "<span class='text-muted'>#{messages[1]}</span>" +
      "</button>").html_safe
    else
      ("<button class='btn-link' type='submit'>" +
        "<span class='text-cart'>#{messages[2]}</span>" +
      "</button>").html_safe
    end
  end
end
