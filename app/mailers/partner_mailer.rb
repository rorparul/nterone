class PartnerMailer < ApplicationMailer
  def registration_made(user, event)
    @user  = user
    @event = event
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))
    mail(to: @user.referring_partner_email,
        #  bcc: ["ashlie@nterone.com", "leslie@nterone.com"], TODO: Uncomment after completion
         subject:       'NterOne Web Student Added Confirmation',
         template_path: 'mailers',
         template_name: 'student_added')
  end
end
