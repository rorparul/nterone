module EventHelper
  def formatted_language(language)
    return 'English' if language == 'en'
    return 'Spanish' if language == 'es'
  end

  def formatted_time_zone(time_zone)
    return 'EST' if time_zone == 'Eastern Time (US & Canada)'
  end

  def instructors_with_rate(instructors, event)
    if event.present?
      selected_instructor = event.instructor

      if selected_instructor.present?
        instructors << selected_instructor
      end
       
      if event.format.present? && (event.format == "On-site" || event.format == "Live Online")
        instructor_with_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: #{event.format}: $#{number_with_delimiter(number_with_precision(user.daily_rate(event), precision: 2))}", user.id] if user.daily_rate(event) > 0}

        instructor_without_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: #{event.format}: $#{number_with_delimiter(number_with_precision(user.daily_rate(event), precision: 2))}", user.id] if user.daily_rate(event) == 0}
      else
        instructor_with_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: On-site: $#{number_with_delimiter(number_with_precision(user.onsite_daily_rate, precision: 2))}, On-line: $#{number_with_delimiter(number_with_precision(user.online_daily_rate, precision: 2))}", user.id] if user.daily_rate(event) > 0}

        instructor_without_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: On-site: $#{number_with_delimiter(number_with_precision(user.onsite_daily_rate, precision: 2))}, On-line: $#{number_with_delimiter(number_with_precision(user.online_daily_rate, precision: 2))}", user.id] if user.daily_rate(event) == 0}
      end
      
      instructor_with_price.compact + instructor_without_price.compact
    else
      instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: On-site: $#{number_with_delimiter(number_with_precision(user.onsite_daily_rate, precision: 2))}, On-line: $#{number_with_delimiter(number_with_precision(user.online_daily_rate, precision: 2))}", user.id] }
    end 
  end
end
