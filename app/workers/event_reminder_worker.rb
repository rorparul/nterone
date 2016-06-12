class EventReminderWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    events = Event.where('start_date > ?', Time.now).where(should_remind: true)

    events.each do |event|
      should_sent = (remind_time(event) .. event.start_date).cover?(Time.now)
      
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
end
