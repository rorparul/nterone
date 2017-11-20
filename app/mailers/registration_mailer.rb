class RegistrationMailer < ApplicationMailer
  def registration_made(seller, user, event)
    @tld          = Rails.application.config.tld
    @user         = user
    @event        = event
    @seller_email = seller.email

    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))

    mail(
      to: @seller_email,
      bcc: ["leslie@nterone.com", "jackie@nterone.ca"],
      subject:       'NterOne Registration Confirmation',
      template_path: 'mailers',
      template_name: 'student_added'
    )
  end

  def create(order)
    @tld            = Rails.application.config.tld
    @order          = order
    @user           = order.buyer
    sales_rep_email = order.seller.try(:email)

    attachments.inline["logo.png"] = File.read(Rails.root.join("app/assets/images/logo.png"))

    mail(
      to: [sales_rep_email],
      bcc: ["leslie@nterone.com", "jackie@nterone.ca"],
      subject:       'NterOne Registration Confirmation',
      template_path: 'mailers',
      template_name: 'student_added'
    )
  end
end
