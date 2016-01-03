class Announcement < ActiveRecord::Base
  has_many :messages, dependent: :destroy

  validates :content, presence: true
end
