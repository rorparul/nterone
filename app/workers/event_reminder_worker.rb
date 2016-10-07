class EventReminderWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    events = Event.remind_needed

    events.each do |event|
      if (remind_time(event) .. event.start_date).cover?(Time.now)
        sent_reminders(event)
      end
    end
  end

  private

  def remind_time(event)
    case event.remind_period
    when 'one_week'
      event.start_date - 1.week
    when 'two_week'
      event.start_date - 2.week
    when 'one_month'
      event.start_date - 1.month
    end
  end

  def sent_reminders(event)
    event.users.each do |user|
      EventMailer.reminder(event, user).deliver_now
    end

    event.update(reminder_sent: true)
  end
end
