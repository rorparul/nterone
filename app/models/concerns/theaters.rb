module Theaters
  extend ActiveSupport::Concern

  included do
    enum theater: {
      united_states: 0,
      latin_america: 1,
      canada: 2
    }
  end
end
