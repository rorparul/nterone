class GroupItem < ActiveRecord::Base
  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates :group_id, :groupable_id, :groupable_type, presence: true
end
