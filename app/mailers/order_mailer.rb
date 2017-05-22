class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @tld   = Rails.application.config.tld
    @user  = user
    @order = order

    mad360_emails = {
      ca: 'marketing360+m10780@bcc.mad360.net',
      com: 'marketing360+m9874@bcc.mad360.net',
      la: 'marketing360+m10794@bcc.mad360.net'
    }

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}",
        'stephanie.pouse@madwiremedia.com',
        mad360_emails[@tld.to_sym]
      ],
      subject: "NterOne.#{@tld} Order Confirmation"
    )
  end

  def lab_rental_notification(user, order_pods)
    @user = user
    @pods = order_pods

    mail(
      to: ['helpdesk@nterone.com', 'techsupport@nterone.com'],
      subject: 'POD Rental'
    )
  end
end
