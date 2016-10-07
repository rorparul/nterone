# == Schema Information
#
# Table name: announcements
#
#  id         :integer          not null, primary key
#  content    :text
#  audience   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  status     :string           default("open")
#  poster     :string
#

class Announcement < ActiveRecord::Base
  has_many :messages, dependent: :destroy

  validates :content, presence: true
end
