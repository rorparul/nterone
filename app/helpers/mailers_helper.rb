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
end
