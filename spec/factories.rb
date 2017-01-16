FactoryGirl.define do
  factory :user do
    name 'Ross'
    password 'verysecurepassword'
    password_confirmation 'verysecurepassword'
  end

  factory :chat do
    name 'Share'
  end

  factory :chats_user do
    association :chat
    association :user

    unread_messages 0
  end

  factory :message do
    content 'some message'

    chat
    user
  end
end
