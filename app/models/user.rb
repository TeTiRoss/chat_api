class User < ApplicationRecord
  has_many :chats_users, dependent: :destroy
  has_many :chats, through: :chats_users
  has_many :messages

  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  has_secure_password
end
