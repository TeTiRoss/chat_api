class Chat < ApplicationRecord
  validates :name, :user_ids, presence: true
  validates :name, uniqueness: true

  has_many :chats_users, dependent: :destroy
  has_many :users, through: :chats_users
  has_many :messages, dependent: :destroy
end
