module MailersHelper
  def format_address(object)
    address = []
    address <<  object.street unless object.street.empty?
    address <<  object.city unless object.city.empty?
    address <<  object.state unless object.state.empty?
    address <<  object.zipcode unless object.zipcode.empty?
    address.map(&:inspect).join(", ").gsub!('"', '')
  end

  def format_timezone(object)
    ", #{object.time_zone}" unless object.time_zone.empty?
  end

  def format_time_with_time_zone(time, time_zone)
    raise "Requires class type Time" unless time.class == Time

    if time.present? && time_zone.present?
      "#{time.strftime("%I:%M%p")}, #{time_zone}"
    elsif time.present?
      time.strftime("%I:%M%p")
    end
  end
end

#{@event.start_time.strftime("%I:%M%p")}" +  "#{format_timezone(@event)}
