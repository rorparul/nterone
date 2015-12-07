class Group < ActiveRecord::Base
  belongs_to :platform

  has_many :subject_groups, dependent: :destroy
  has_many :subjects,       through: :subject_groups
  has_many :group_items,    dependent: :destroy

  accepts_nested_attributes_for :group_items, allow_destroy: true
end
