class PartnerMailer < ApplicationMailer
  def registration_made(partner_email, user, event)
    @user  = user
    @event = event
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))
    mail(to: partner_email,
         bcc: ['ashlie@nterone.com', 'leslie@nterone.com'],
         subject:       'NterOne Web Student Added Confirmation',
         template_path: 'mailers',
         template_name: 'student_added')
  end
end
