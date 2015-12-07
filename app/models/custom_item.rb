class CustomItem < ActiveRecord::Base
  belongs_to :platform

  has_many :group_items, as: :groupable
end
