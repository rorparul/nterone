class BrandFavicon < ActiveRecord::Base
  include Imageable

  belongs_to :brand

  has_one :favicon, as: :imageable, class_name: 'Image', dependent: :destroy

  accepts_nested_attributes_for :favicon
end
