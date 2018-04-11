module EventHelper
  def formatted_language(language)
    return 'English' if language == 'en'
    return 'Spanish' if language == 'es'
  end

  def formatted_time_zone(time_zone)
    return 'EST' if time_zone == 'Eastern Time (US & Canada)'
  end

  def instructors_with_rate(instructors) 
    instructors.collect { |user| ["#{user.last_name}, #{user.first_name}: $#{number_with_delimiter(number_with_precision(user.daily_rate, precision: 2))}", user.id] }
  end


end
