module Regions
  extend ActiveSupport::Concern

  class_methods do
    def options_for_origin_regions
      origin_regions.keys.sort.map { |region| [region.titleize, region] }
    end
  end

  included do
    enum origin_region: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }

    after_initialize :set_origin_region, if: proc { |model| model.new_record? }
  end

  def current_region
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

  def set_origin_region
    self.origin_region = current_region
  end
end
