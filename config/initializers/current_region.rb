
Rails.application.config.current_region = case Rails.application.config.tld
  when 'com'
    0
  when 'la'
    1
  when 'ca'
    2
  else
    0
  end
