class EventMailer < ApplicationMailer
  def reminder(event, user)
    @event = event
    @user  = user

    mail(
      to: user.email,
      subject: 'Class Reminder'
    )
  end

  def create_gtr_alert(event)
    @event = event

    mail(
      to: ['helpdesk@nterone.com', 'helpdesk@nterone.la', 'helpdesk@nterone.ca'],
      subject: "New GTR on #{`hostname`}",
      template_name: 'gtr_alert'
    )
  end

  def destroy_gtr_alert(event)
    @event = event

    mail(
      to: ['helpdesk@nterone.com', 'helpdesk@nterone.la', 'helpdesk@nterone.ca'],
      subject: "Canceled GTR on #{`hostname`}",
      template_name: 'gtr_alert'
    )
  end
end
