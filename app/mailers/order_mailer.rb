class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    @tld   = Rails.application.config.tld

    mail(
      to: @user.email,
      bcc: [
        "sales@nterone.#{@tld}",
        "helpdesk@nterone.#{@tld}",
        "billing@nterone.#{@tld}",
        'stephanie.pouse@madwiremedia.com',
        'marketing360+m9874@bcc.mad360.net',
        'marketing360+M10780@bcc.mad360.net',
        'marketing360+M10794@bcc.mad360.net'
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
