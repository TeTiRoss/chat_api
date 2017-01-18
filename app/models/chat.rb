class Chat < ApplicationRecord
  has_many :chats_users, dependent: :destroy
  has_many :users, through: :chats_users
  has_many :messages, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :users, length: { minimum: 2 }

  def set_as_read(user)
    self.messages.mark_as_read! :all, for: user
  end
end
