class MessagesController < ApplicationController
  def index
    @messages = []
    current_user.messages.each do |message|
      message.read = true
      message.save
      @messages << message.announcement if message.announcement.status == 'open'
    end
    @messages.reverse!
    @message_count = current_user.new_message_count
  end
end
