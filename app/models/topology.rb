# == Schema Information
#
# Table name: topologies
#
#  id             :integer          not null, primary key
#  lab_course_id  :integer
#  created_at     :datetime
#  updated_at     :datetime
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class Topology < ActiveRecord::Base
  include Imageable

  belongs_to :lab_course

  has_one  :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image
end
