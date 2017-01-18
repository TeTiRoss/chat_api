class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user

  validates :content, presence: true

  after_create :increment_user_messages_count, :read_by_creator

  delegate :name, to: :user, prefix: true
  delegate :id, to: :chat, prefix: true
  delegate :id, to: :user, prefix: true

  acts_as_readable on: :created_at

  private

    def increment_user_messages_count
      User.increment_counter(:messages_count, self.user)
    end

    def read_by_creator
      self.mark_as_read! for: self.user
    end
end
