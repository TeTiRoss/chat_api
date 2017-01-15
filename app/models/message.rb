class Message < ApplicationRecord
  validates :content, presence: true

  belongs_to :chat
  belongs_to :user

  delegate :name, to: :user, prefix: true
end
