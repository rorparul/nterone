 class Announcement < ActiveRecord::Base
  belongs_to :brand
  has_many   :messages, dependent: :destroy
end
