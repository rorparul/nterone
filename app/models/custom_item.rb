# == Schema Information
#
# Table name: custom_items
#
#  id             :integer          not null, primary key
#  content        :text
#  shortname      :string
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  platform_id    :integer
#  is_header      :boolean          default(FALSE)
#  origin_region  :integer
#  active_regions :text             default([]), is an Array
#  archived       :boolean          default(FALSE)
#
# Indexes
#
#  index_custom_items_on_origin_region  (origin_region)
#

class CustomItem < ActiveRecord::Base
  include Regions

  belongs_to :platform

  has_many :group_items, as: :groupable, dependent: :destroy

  validates :shortname, presence: true
  validates :content,   presence: true

  after_initialize :set_all_regions, if: :new_record?
end
