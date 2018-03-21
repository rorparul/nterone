module Regions
  extend ActiveSupport::Concern

  included do
    scope :current_region, -> { where("#{self.table_name}.active_regions @> ?", "{#{self.origin_regions.key(self.get_session_region)}}") }

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

    def options_for_origin_region
      origin_regions.map {|region, region_value| [region.titleize, region_value]}
    end

    def get_session_region
      if Rails.env.test?
        1
      else
        try(:session) && session[:region] || 0
      end
    end
  end

  def current_region_as_key
    self.class.origin_regions.key(current_region_as_value)
  end

  def current_region_as_value
    get_session_region
  end

  def get_session_region
    if Rails.env.test?
      1
    else
      try(:session) && session[:region] || 0
    end
  end

  def set_all_regions
    self.active_regions = self.class.origin_regions.keys
  end

  def current_region_available?
    active_regions.include? self.class.origin_regions.key(self.get_session_region)
  end

  private

  def set_origin_region
    self.origin_region ||= current_region_as_value if self.class.column_names.include?("origin_region")
  end
end
