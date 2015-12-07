class VisualAsset < ActiveRecord::Base
  include Imageable
  
  belongs_to :brand

  has_one :email_logo, as: :imageable, class_name: 'Image', dependent: :destroy

  accepts_nested_attributes_for :email_logo
end
