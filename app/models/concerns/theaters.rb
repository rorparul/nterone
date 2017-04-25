module Theaters
  extend ActiveSupport::Concern

  included do
    enum theater: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }
  end

  def current_theater
    case Rails.application.config.tdl
    when 'com'
      0
    when 'la'
      1
    when 'ca'
      2
    else
      0
    end
  end
end
