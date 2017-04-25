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
#  theater          :integer
#

class Page < ActiveRecord::Base
  extend FriendlyId

  include Theaters

  friendly_id :title, use: [:slugged, :finders]

  after_initialize :set_theater

  scope :default, -> { where(theater: current_theater) }

  private

  def set_theater
    self.theater ||= current_theater
  end
end
