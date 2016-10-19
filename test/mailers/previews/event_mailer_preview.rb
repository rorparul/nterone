class EventMailerPreview < ActionMailer::Preview
  def reminder
    user = User.first
    event = Event.first
    EventMailer.reminder(event, user)
  end
end
