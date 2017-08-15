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

class Announcement < ActiveRecord::Base
  include Regions

  has_many :messages, dependent: :destroy

  validates :content, presence: true
end
