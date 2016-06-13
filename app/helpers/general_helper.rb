module GeneralHelper
  def personal_greeting
    personal_greeting = "Guest"
    if user_signed_in?
      if current_user.first_name.present?
        personal_greeting = current_user.first_name
      else
        if current_user.admin?
          personal_greeting = "Admin"
        elsif current_user.sales?
          personal_greeting = "Sales"
        else
          personal_greeting = "Member"
        end
      end
    end
    "<span class='text'>Welcome #{personal_greeting}<span/>".html_safe
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

  def passed_exam(user, exam)
    user.passed_exams.any? do |passed_exam|
      passed_exam.exam == exam
    end
  end

  def video_status(user, video)
    if user
      if WatchedVideo.find_by(user_id: user.id, video_id: video.id)
        "<span class='fa fa-check text-success'></span>".html_safe
      end
    end
  end

  def formatted_price_or_range_of_upcoming_events_for(course)
    events = course.upcoming_events.order(:price)
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
end

def contact_info(user)
  phone = user.contact_number || ''
  email = user.email || ''

  [phone, email].join(' ')
end

def dollar_value(price)
  "$#{price}"
end
