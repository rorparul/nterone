class Article < ActiveRecord::Base
  extend FriendlyId

  validates :kind, :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
