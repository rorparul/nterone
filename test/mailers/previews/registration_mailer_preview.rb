class RegistrationMailerPreview < ActionMailer::Preview
  def registration_made
    user = User.first
    event = Event.first
    order = Order.first
    RegistrationMailer.registration_made(user, user, event, order)
  end
end
