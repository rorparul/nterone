# == Schema Information
#
# Table name: pages
#
#  id               :integer          not null, primary key
#  title            :string
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  page_title       :string
#  slug             :string
#  static           :boolean          default(FALSE)
#  page_description :text
#  origin_region    :integer
#  active_regions   :text             default([]), is an Array
#
# Indexes
#
#  index_pages_on_origin_region  (origin_region)
#

class Page < ActiveRecord::Base
  extend FriendlyId

  include Regions

  # default_scope { where(origin_region: self.get_session_region) }

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:title, [:title, :origin_region]]
  end
end
