# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  announcement_id :integer
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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
