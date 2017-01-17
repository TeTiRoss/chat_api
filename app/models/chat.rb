class Chat < ApplicationRecord
  has_many :chats_users, dependent: :destroy
  has_many :users, through: :chats_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :users, length: { minimum: 2 }

  def clear_unread_messages(user)
    chats_user = chats_users.find_by(user_id: user.id)
    chats_user.unread_messages = 0
    chats_user.save
  end
end
