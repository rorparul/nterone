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
#

class GroupItem < ActiveRecord::Base
  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates :groupable, presence: true
end
