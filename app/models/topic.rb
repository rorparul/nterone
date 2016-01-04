class Topic < ActiveRecord::Base
  belongs_to :forum
  has_many   :posts, dependent: :destroy

  validates :title, :forum, presence: true
  validates_associated :forum
end
