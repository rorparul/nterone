module Regions
  extend ActiveSupport::Concern

  included do
    scope :current_region, -> { where("#{self.table_name}.active_regions @> ?", "{#{self.origin_regions.key(self.get_session_region)}}") }

    enum origin_region: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }

    # default_scope { where(origin_region: self.get_session_region) }

    after_initialize :set_origin_region, if: proc { |model| model.new_record? }
  end

  class_methods do
    def options_for_regions
      origin_regions.keys.sort.map { |region| [region.titleize, region] }
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

  private

  def set_origin_region
    self.origin_region ||= current_region_as_value if self.class.column_names.include?("origin_region")
  end
end
