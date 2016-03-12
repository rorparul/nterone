class Article < ActiveRecord::Base
  extend FriendlyId
  include Bootsy::Container

  validates :kind, :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
