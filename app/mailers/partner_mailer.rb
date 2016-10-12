class PartnerMailer < ApplicationMailer
  def registration_made(email, user, event)
    @user  = user
    @event = event
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))
    mail(to: email,
         bcc: ["ashlie#{I18n.t('email')}", "leslie#{I18n.t('email')}"],
         subject:       'NterOne Web Student Added Confirmation',
         template_path: 'mailers',
         template_name: 'student_added')
  end
end
