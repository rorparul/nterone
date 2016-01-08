class OrderMailer < ApplicationMailer
  def confirmation(user, order)
    @user  = user
    @order = order
    mail(to: @user.email, subject: 'NterOne.com Order Confirmation')
  end
end
