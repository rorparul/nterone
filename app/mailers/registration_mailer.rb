class RegistrationMailer < ApplicationMailer
  def registration_made(seller, user, event)
    @user                          = user
    @event                         = event
    @seller_email                  = seller.email
    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))

    mail(
      to: @seller_email,
      bcc: ["ashlie#{I18n.t('email')}", "leslie#{I18n.t('email')}"],
      subject:       'NterOne Web Student Added Confirmation',
      template_path: 'mailers',
      template_name: 'student_added'
    )
  end
end
