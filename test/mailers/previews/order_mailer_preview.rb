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
end
