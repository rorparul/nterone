module Regions
  extend ActiveSupport::Concern

  included do
    scope :active_in_current_region, -> { where("active_regions @> ?", "{#{self.new.current_region_as_key}}") }

    enum origin_region: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }

    after_initialize :set_origin_region, if: proc { |model| model.new_record? }
  end

  class_methods do
    def options_for_regions
      origin_regions.keys.sort.map { |region| [region.titleize, region] }
    end
  end

  def current_region_as_key
    self.class.origin_regions.key(current_region_as_value)
  end

  def current_region_as_value
    case Rails.application.config.tld
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

  private

  def set_origin_region
    self.origin_region ||= current_region_as_value  if self.class.column_names.include?("origin_region")
  end
end
