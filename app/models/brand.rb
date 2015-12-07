class Brand < ActiveRecord::Base
  include Imageable

  validates :title, :url, presence: true, uniqueness: true

  has_many :forums
  has_many :topics, through: :forums
  has_many :platforms
  has_many :brand_users
  has_many :users, through: :brand_users
  has_many :announcements
  has_many :leads

  has_one  :logo, as: :imageable, class_name: 'Image', dependent: :destroy
  accepts_nested_attributes_for :logo

  has_one :visual_asset, dependent: :destroy
  accepts_nested_attributes_for :visual_asset

  has_one :brand_favicon, dependent: :destroy
  accepts_nested_attributes_for :brand_favicon


  def default_img_name
    'logo.png'
  end
end
