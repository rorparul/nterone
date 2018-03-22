module EventHelper
  def formatted_language(language)
    return 'English' if language == 'en'
    return 'Spanish' if language == 'es'
  end

  def formatted_time_zone(time_zone)
    return 'EST' if time_zone == 'Eastern Time (US & Canada)'
  end
end
