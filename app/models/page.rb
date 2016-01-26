class Page < ActiveRecord::Base
  include Bootsy::Container
  
  validates :title, :content, presence: true
end
