class OrderMailerPreview < ActionMailer::Preview
  def confirmation
    user = User.first
    order = Order.first
    OrderMailer.confirmation(user, order)
  end
end
