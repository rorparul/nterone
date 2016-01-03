class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :announcement

  validates :user, :announcement, presence: true

  def self.active(user)
    if user
      user.messages.select do |message|
        message if message.announcement.status == 'open'
      end
    else
      []
    end
  end
end
