module MessageManager
  extend ActiveSupport::Concern

  def mark_messages_read(user)
    user.messages.each do |message|
      message.read = true
      message.save
    end
  end
end
