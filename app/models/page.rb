class Page < ActiveRecord::Base
  validates :title, :content, presence: true
end
