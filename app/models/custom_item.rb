class CustomItem < ActiveRecord::Base
  belongs_to :platform

  has_many :group_items, as: :groupable, dependent: :destroy

  validates :shortname, presence: true
  validates :content,   presence: true
end
