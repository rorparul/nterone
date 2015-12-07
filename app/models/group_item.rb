class GroupItem < ActiveRecord::Base
  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates_presence_of :groupable_id
end
