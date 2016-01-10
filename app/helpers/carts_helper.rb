module CartsHelper
  def cc_years
    yrs = []
    year_today = Date.today.strftime("%y").to_i
    year_today.upto(year_today+10).each do |y| yrs << y.to_s;end
    return yrs
  end

  def cc_months
    ['01','02','03','04','05','06','07','08','09','10','11','12']
  end

  # def link_to_cart(item)
  #   "#{form_for :order_item, url: order_items_path do |f|}"
  #   if item.class == Event
  # end
  #
  # = form_for :order_item, url: order_items_path do |f|
  #   = f.hidden_field :event_id, value: event.id
  #   button.btn.btn-link.text-success type="submit" Add to cart
  #
  #
  #   = form_for :order_item, url: order_items_path do |f|
  #     = f.hidden_field :event_id, value: event.id
  #     button.btn.btn-link type="submit" Add to cart
  #
  #     = form_for :order_item, url: order_items_path do |f|
  #       = f.hidden_field :video_on_demand_id, value: @video_on_demand.id
  #       button.btn.btn-link.text-success type="submit" Add to cart
end
