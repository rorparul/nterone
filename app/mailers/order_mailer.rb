class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    mail(to: @user.email,
        #  bcc: ["sales@nterone.com", "helpdesk@nterone.com", "billing@nterone.com"],
         subject: 'NterOne.com Order Confirmation')
  end
end
