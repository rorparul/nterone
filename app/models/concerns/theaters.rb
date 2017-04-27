module Theaters
  extend ActiveSupport::Concern

  class_methods do
    def options_for_theaters
      theaters.keys.sort.map { |theater| [theater.titleize, theater] }
    end
  end

  included do
    enum theater: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }

    after_initialize :set_theater, if: proc { |model| model.new_record? }
  end

  def current_theater
    case Rails.application.config.tld
    when 'com'
      0
    when 'la'
      1
    when 'ca'
      2
    end
  end

  private

  def set_theater
    self.theater = current_theater
  end
end
