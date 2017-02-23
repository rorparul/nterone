class Topology < ActiveRecord::Base
  include Imageable

  belongs_to :lab_course

  has_one  :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image
end
