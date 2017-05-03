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

class Page < ActiveRecord::Base
  extend FriendlyId

  include Regions

  scope :default, -> { where(origin_region: current_region) }

  friendly_id :title, use: [:slugged, :finders]
end
