class Page < ActiveRecord::Base
  extend FriendlyId
  include Bootsy::Container

  # validates :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
