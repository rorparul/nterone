class RegistrationMailerPreview < ActionMailer::Preview
  def registration_made
    user = User.first
    event = Event.first
    partner_email = user.email
    RegistrationMailer.registration_made(partner_email, user, event)
  end
end
