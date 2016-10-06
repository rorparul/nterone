class PartnerMailerPreview < ActionMailer::Preview
  def registration_made
    user = User.first
    event = Event.first
    partner_email = user.email
    PartnerMailer.registration_made(partner_email, user, event)
  end
end
