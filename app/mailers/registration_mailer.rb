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

  def confirmation(order_item)
    sales_rep_email = order_item.order.seller.try(:email)
    partner_email   = order_item.order.referring_partner_email
    customer_email  = order_item.order.buyer.try(:email)

    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))

    mail(
      to: [sales_rep_email, partner_email, customer_email],
      bcc: ["ashlie#{I18n.t('email')}", "leslie#{I18n.t('email')}"],
      subject:       'Registration Confirmation',
      template_path: 'mailers',
      template_name: 'student_added'
    )
  end
end
