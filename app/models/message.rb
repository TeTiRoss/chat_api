class Message < ApplicationRecord
  validates :content, presence: true

  belongs_to :chat
  # TODO remove optional
  belongs_to :user, optional: true

  delegate :name, to: :user, prefix: true
  delegate :id, to: :chat, prefix: true
end
