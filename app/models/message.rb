class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :announcement

  # def self.unread(user)
  #   if user
  #     user.messages.where(read: false).collect do |message|
  #       message.announcement if message.announcement.status == 'open'
  #     end
  #   else
  #     []
  #   end
  # end

  def self.active(user)
    if user
      user.messages.collect do |message|
        message.announcement if message.announcement.status == 'open'
      end
    end
  end
end
