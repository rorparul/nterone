module EventHelper
  def formatted_language(language)
    return 'English' if language == 'en'
    return 'Spanish' if language == 'es'
  end

  def formatted_time_zone(time_zone)
    return 'EST' if time_zone == 'Eastern Time (US & Canada)'
  end

  def instructors_with_rate(instructors, event)
    selected_instructor = event.instructor
    if selected_instructor.present?
      instructors << selected_instructor
    end
    instructor_with_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: $#{number_with_delimiter(number_with_precision(user.daily_rate, precision: 2))}", user.id] if user.daily_rate > 0}

    instructor_without_price = instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: $#{number_with_delimiter(number_with_precision(user.daily_rate, precision: 2))}", user.id] if user.daily_rate == 0}
    
    instructor_with_price.compact + instructor_without_price.compact
  end
end
