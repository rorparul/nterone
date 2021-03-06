module GeneralHelper
  def formatted_domain
    top_level = request.host.match(/\w+$/).to_s
    "www.NterOne.#{top_level}"
  end

  def existing_select2_ajax_user(user)
    if user.present?
      [["#{user.last_name}, #{user.first_name}", user.id]]
    else
      []
    end
  end

  def existing_select2_ajax_company(company)
    if company.present?
      [[company.title, company.id]]
    else
      []
    end
  end

  def planned_course(user, course)
    user.chosen_courses.where(planned: true).any? do |chosen_course|
      chosen_course.course == course
    end
  end

  def attended_course(user, course)
    user.chosen_courses.where(attended: true).any? do |chosen_course|
      chosen_course.course == course
    end
  end

  def formatted_price_or_range_of_upcoming_events_for(course)
    events = course.upcoming_public_events.order(:price)

    if events.any?
      if events.first.price == events.last.price
        "$#{number_with_delimiter(number_with_precision(events.first.price, precision: 2))}"
      else
        "$#{number_with_delimiter(number_with_precision(events.first.price, precision: 2))} - $#{number_with_delimiter(number_with_precision(events.last.price, precision: 2))}"
      end
    else
      'N/A'
    end
  end

  def formatted_price_or_range_of_my_plan_for(user)
    low  = user.my_plan_total_low
    high = user.my_plan_total_high

    unless low == nil && high == nil
      if low == nil
        "$#{number_with_delimiter(number_with_precision(high, precision: 2))}"
      elsif high == nil
        "$#{number_with_delimiter(number_with_precision(low, precision: 2))}"
      else
        if low == high
          "$#{number_with_delimiter(number_with_precision(low, precision: 2))}"
        else
          "$#{number_with_delimiter(number_with_precision(low, precision: 2))} - $#{number_with_delimiter(number_with_precision(high, precision: 2))}"
        end
      end
    else
      '$0.00'
    end
  end

  def comma_seperate(collection, attribute = nil)
    string = ""
    if attribute
      collection.each do |item|
        string += "#{item.send(attribute).humanize.titleize}, "
      end
    else
      collection.each do |item|
        string += "#{item.humanize.titleize}, "
      end
    end
    string[0...-2]
  end

  def time_diff(start_time, end_time)
    return 'uknown' if start_time.blank? || end_time.blank?

    seconds_diff = (start_time - end_time).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end

  def events_revenue_total(events)
    events.inject(0) { |sum, event| sum + event.revenue }
  end

  def contact_info(user)
    phone = user.contact_number || ''
    email = user.email || ''

    [phone, email].join(' ')
  end

  def dollar_value(price)
    if price.to_s[-2] == "."
      "$#{price}" + "0"
    else
      "$#{price}"
    end
  end

  def number_in_words(int)
    numbers_to_name = {
        1000000 => "million",
        1000 => "thousand",
        100 => "hundred",
        90 => "ninety",
        80 => "eighty",
        70 => "seventy",
        60 => "sixty",
        50 => "fifty",
        40 => "forty",
        30 => "thirty",
        20 => "twenty",
        19=>"nineteen",
        18=>"eighteen",
        17=>"seventeen",
        16=>"sixteen",
        15=>"fifteen",
        14=>"fourteen",
        13=>"thirteen",
        12=>"twelve",
        11 => "eleven",
        10 => "ten",
        9 => "nine",
        8 => "eight",
        7 => "seven",
        6 => "six",
        5 => "five",
        4 => "four",
        3 => "three",
        2 => "two",
        1 => "one"
      }
    str = ""
    numbers_to_name.each do |num, name|
      if int == 0
        return str
      elsif int.to_s.length == 1 && int/num > 0
        return str + "#{name}"
      elsif int < 100 && int/num > 0
        return str + "#{name}" if int%num == 0
        return str + "#{name} " + number_in_words(int%num)
      elsif int/num > 0
        return str + number_in_words(int/num) + " #{name} " + number_in_words(int%num)
      end
    end
  end

  def nested_options(resources)
    options = []

    resources.walk_tree do |resource, level|
      options << ["#{'|_____' * level}#{' ' if level > 0}#{resource.title}", resource.id]
    end

    options
  end

  def surname_ordered_options(resources)
    resources.collect do |resource|
      first_name = resource.first_name
      last_name  = resource.last_name
      compound   = "#{last_name + ', ' if last_name.present?}#{first_name}"

      compound.present? ? [compound, resource.id] : [resource.email, resource.id]
    end
  end

  # First argument is an array/collection of AR objects
  # Second argument is a string with the same name as a numerical attribute on that object
  def sum_of(objects, attribute)
    symbol = attribute.to_sym
    sum = 0
    objects.each do |object|
      unless object.send(symbol).nil?
        sum += object.send(symbol)
      end
    end
    return sum
  end

  # First arument is an array
  # Second argument is the Class of the objects contained in the array
  def array_to_records(array, object)
    array = array.map {|i| i.id }
    return object.where(id: array)
  end

  def array_to_numbers_with_delimiters (array)
    array.map{|element| "$#{number_with_delimiter(element)}"}
  end

  def array_percentages_of_total(grand_total, array)
    grand_total > 0 ? array.map{|total| "#{((total*100)/grand_total).round(2)}%"} : array.map{|total| "0%"}
  end
end
