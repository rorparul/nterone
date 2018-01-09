module EventHelper
  def formatted_language(language)
    return 'en-US' if language == 'en'
    return 'es-MX' if language == 'es'
    return 'N/A'
  end

  def formatted_time_zone(time_zone)
    return 'EST' if time_zone == 'Eastern Time (US & Canada)'
    return 'N/A'
  end
end
