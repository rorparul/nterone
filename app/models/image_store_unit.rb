class ImageStoreUnit < ActiveRecord::Base
  include Imageable

  has_one  :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :image, presence: true
end
