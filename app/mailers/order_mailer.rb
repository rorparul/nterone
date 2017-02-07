class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    # mail(to: @user.email,
    #      bcc: ["sales#{I18n.t('email')}", "helpdesk#{I18n.t('email')}", "billing#{I18n.t('email')}", 'stephanie.pouse@madwiremedia.com', 'marketing360+m9874@bcc.mad360.net'],
    #      subject: 'NterOne.com Order Confirmation')
  end

  def lab_rental_notification(user, order_pods)
    @user       = user
    @pods       = order_pods
    mail(to: ['helpdesk@nterone.com', 'techsupport@nterone.com'],
         subject: 'POD Rental')
  end
end
