class EventMailer < ApplicationMailer
  def reminder(event, user)
    @event = event
    @user = user

    mail(to: user.email, subject: 'Class Reminder')
  end
end
