# == Schema Information
#
# Table name: group_items
#
#  id             :integer          not null, primary key
#  groupable_id   :integer
#  groupable_type :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  group_id       :integer
#  position       :integer
#  origin_region  :integer
#
# Indexes
#
#  index_group_items_on_groupable_type_and_groupable_id  (groupable_type,groupable_id)
#

class GroupItem < ActiveRecord::Base
  include Regions

  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates :groupable, presence: true
end
