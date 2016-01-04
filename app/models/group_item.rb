class GroupItem < ActiveRecord::Base
  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates :groupable, presence: true
end
