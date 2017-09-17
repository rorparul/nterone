class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    user = User.first
    order = Order.first
    OrderMailer.confirmation(user, order)
  end

  def lab_rental_notification
    user = User.first
    pods = LabRental.where(level: 'individual')
    OrderMailer.lab_rental_notification(user, pods)
  end

  def you_have_left_order_items
    user = User.first
    cart_id = Cart.joins(:order_items).group("order_items.cart_id").having("count(order_items.cart_id) > 2").count.first.first
    cart = Cart.find(cart_id)
    cart.update user: user
    cart.order_items.each do |item|
      item.update user: user
    end
    OrderMailer.you_have_left_order_items cart
  end
end
