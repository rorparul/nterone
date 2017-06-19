# == Schema Information
#
# Table name: groups
#
#  id             :integer          not null, primary key
#  header         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  platform_id    :integer
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#

class Group < ActiveRecord::Base
  include Regions

  # belongs_to :platform

  has_many :subject_groups, dependent: :destroy
  has_many :subjects,       through: :subject_groups
  has_many :group_items,    dependent: :destroy

  accepts_nested_attributes_for :group_items, allow_destroy: true

  validates            :header, presence: true
  validates_associated :group_items
end
