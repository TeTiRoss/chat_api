class User < ApplicationRecord
  has_many :chats_users, dependent: :destroy
  has_many :chats, through: :chats_users
  has_many :messages

  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  before_create :set_auth_token

  has_secure_password

  private
    def set_auth_token
      return if auth_token.present?
      self.auth_token = generate_auth_token
    end

    def generate_auth_token
      SecureRandom.uuid.gsub(/\-/,'')
    end
end
