class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true

  after_create :increment_sent_messages, :increment_unread_messages

  delegate :name, to: :user, prefix: true
  delegate :id, to: :chat, prefix: true
  delegate :id, to: :user, prefix: true

  private
    def increment_sent_messages
      User.increment_counter(:messages_count, user)
    end

    def increment_unread_messages
      chat.chats_users.where.not(user_id: user.id).each do |chats_user|
        ChatsUser.increment_counter(:unread_messages, chats_user)
      end
    end
end
