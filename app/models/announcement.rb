# == Schema Information
#
# Table name: announcements
#
#  id             :integer          not null, primary key
#  content        :text
#  audience       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  status         :string           default("open")
#  poster         :string
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#
# Indexes
#
#  index_announcements_on_origin_region  (origin_region)
#

class Announcement < ActiveRecord::Base
  include Regions

  has_many :messages, dependent: :destroy

  validates :content, presence: true
end
