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
#  origin_region    :integer
#  active_regions   :text             default([]), is an Array
#
# Indexes
#
#  index_articles_on_origin_region  (origin_region)
#

class Article < ActiveRecord::Base
  extend FriendlyId

  include Regions

  validates :kind, :title, :content, presence: true

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:title, [:title, :origin_region]]
  end
end
