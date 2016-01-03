class CarouselItem < ActiveRecord::Base
  include Imageable

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :image, presence: true

  def self.all_active
    where(active: true)
  end
end
