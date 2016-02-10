module MessageManager
  extend ActiveSupport::Concern

  private

  def mark_messages_read(user)
    user.messages.each do |message|
      message.read = true
      message.save
    end
  end
end
