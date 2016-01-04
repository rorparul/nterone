class Video < ActiveRecord::Base
  belongs_to :video_module

  validates :title, :embed_code, presence: true
end
