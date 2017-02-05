class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    user = User.first
    order = Order.first
    OrderMailer.confirmation(user, order)
  end

  def lab_rental_confirmation
    user = User.first
    order = Order.first
    OrderMailer.lab_rental_confirmation(user, order)
  end
end
