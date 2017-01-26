class EventMailer < ApplicationMailer
  def reminder(event, user)
    @event = event
    @user = user

    mail(
      to: user.email,
      subject: 'Class Reminder'
    )
  end

  def create_gtr_alert(event)
    @event = event

    mail(
      to: "helpdesk#{I18n.t('email')}",
      subject: "New GTR on #{request.host}",
      template: 'gtr_alert'
    )
  end

  def destroy_gtr_alert(event)
    @event = event

    mail(
      to: "helpdesk#{I18n.t('email')}",
      subject: "Canceled GTR on #{request.host}",
      template: 'gtr_alert'
    )
  end
end
