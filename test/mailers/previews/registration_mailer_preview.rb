class RegistrationMailerPreview < ActionMailer::Preview
  def registration_made
    user = User.first
    event = Event.first
    seller_email = user.email
    RegistrationMailer.registration_made(seller_email, user, event)
  end
end
