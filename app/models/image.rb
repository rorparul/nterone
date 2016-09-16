# == Schema Information
#
# Table name: images
#
#  id             :integer          not null, primary key
#  file           :string
#  imageable_id   :integer
#  imageable_type :string
#
# Indexes
#
#  index_images_on_imageable_type_and_imageable_id  (imageable_type,imageable_id)
#

class Image < ActiveRecord::Base
  mount_uploader :file, ImageUploader

  belongs_to :imageable, polymorphic: true

  # validates :file, presence: true
end
