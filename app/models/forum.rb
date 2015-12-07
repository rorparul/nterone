class Forum < ActiveRecord::Base
  belongs_to :brand
  has_many   :topics, dependent: :destroy

  validates :title, presence: true
end
