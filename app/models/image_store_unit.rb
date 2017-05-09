# == Schema Information
#
# Table name: image_store_units
#
#  id            :integer          not null, primary key
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  origin_region :integer
#

class ImageStoreUnit < ActiveRecord::Base
  include Regions
  include Imageable

  has_one  :image, as: :imageable, dependent: :destroy

  accepts_nested_attributes_for :image

  validates :image, presence: true
end
