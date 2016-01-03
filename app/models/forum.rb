class Forum < ActiveRecord::Base
  has_many :topics, dependent: :destroy

  validates :title, presence: true
end
