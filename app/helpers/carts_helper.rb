module CartsHelper
  include CurrentCart

  def cc_years
    yrs = []
    year_today = Date.today.strftime("%y").to_i
    year_today.upto(year_today+10).each do |y| yrs << y.to_s;end
    return yrs
  end

  def cc_months
    ['01','02','03','04','05','06','07','08','09','10','11','12']
  end

  def link_to_cart(item)
    items_in_cart = @cart.order_items.collect do |order_item|
      order_item.orderable
    end

    items_purchased = if user_signed_in?
                        current_user.order_items.collect do |order_item|
                          order_item.orderable
                        end
                      else
                        []
                      end

    if items_in_cart.include?(item)
      ("<button class='btn-link' type='submit' disabled='true'>" +
        "<span class='text-muted'>Item in cart</span>" +
      "</button>").html_safe
    elsif items_purchased.include?(item)
      ("<button class='btn-link' type='submit' disabled='true'>" +
        "<span class='text-muted'>Item purchased</span>" +
      "</button>").html_safe
    else
      ("<button class='btn-link' type='submit'>" +
        "<span class='text-cart'>Add to cart</span>" +
      "</button>").html_safe
    end
  end
end
