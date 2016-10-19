class RegistrationMailer < ApplicationMailer
  def registration_made(target_email, seller, user, event)
    @user                          = user
    @event                         = event
    @seller_email                  = seller.email if seller
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))

    mail(
      to: target_email,
      bcc: ["ashlie#{I18n.t('email')}", "leslie#{I18n.t('email')}", @seller_email],
      subject:       'NterOne Web Student Added Confirmation',
      template_path: 'mailers',
      template_name: 'student_added'
    )
  end
end
