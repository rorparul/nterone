class CarouselItem < ActiveRecord::Base
  include Imageable

  has_one :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates_presence_of :image

  def self.all_active
    where(active: true)
  end

  def default_img_name
    'no_image.png'
  end
end
