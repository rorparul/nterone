class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    mail(to: @user.email,
         bcc: ["sales#{I18n.t('email')}", "helpdesk#{I18n.t('email')}", "billing#{I18n.t('email')}"],
         subject: 'NterOne.com Order Confirmation')
  end
end
