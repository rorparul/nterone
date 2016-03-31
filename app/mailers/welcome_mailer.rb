class WelcomeMailer < ApplicationMailer
  def default(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to NterOne.com!')
  end
end
