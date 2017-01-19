require 'rails_helper'

RSpec.describe Chat, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  it 'can set self as read' do
    user_1 = FactoryGirl.create(:user)
    user_2 = FactoryGirl.create(:user)
    chat = FactoryGirl.create(:chat, users: [user_1, user_2])
    FactoryGirl.create_list(:message, 10, chat: chat, user: user_1)

    expect(Message.unread_by(user_2).size).to eq(10)

    chat.set_as_read(user_2)
    expect(Message.unread_by(user_2).size).to eq(0)
  end
end
