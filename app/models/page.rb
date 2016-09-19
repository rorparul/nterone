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
#

class Page < ActiveRecord::Base
  extend FriendlyId

  # validates :title, :content, presence: true

  friendly_id :title, use: [:slugged, :finders]
end
