# == Schema Information
#
# Table name: articles
#
#  id               :integer          not null, primary key
#  page_title       :string
#  page_description :text
#  content          :text
#  slug             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  kind             :string
#  title            :string
#  theater          :integer
#

class Article < ActiveRecord::Base
  extend FriendlyId

  include Theaters

  scope :default, -> { where(theater: current_theater) }

  validates :kind, :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
