class Page < ActiveRecord::Base
  extend FriendlyId

  # validates :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
