require 'rails_helper'

describe 'Messages API' do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_2) { FactoryGirl.create(:user) }
  let!(:chat) { FactoryGirl.create(:chat, users: [user, user_2]) }

  context 'create message' do
    it 'without token' do
      post "/chats/#{chat.id}/messages"
      expect(response.status).to eq(401)
    end

    it 'without access rights' do
      john = FactoryGirl.create(:user)
      post "/chats/#{chat.id}/messages",
        headers: {'Authorization': "Token token=#{john.auth_token}"}

      expect(response.status).to eq(403)
    end

    it 'with all required fields' do
      post "/chats/#{chat.id}/messages",
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { message: { content: 'Hello!' }, format: :json }

        expect(response.status).to eq(201)

        expect(json['message']['content']).to eq('Hello!')
        expect(json['message']['user_id']).to eq(user.id)
        expect(json['message']['chat_id']).to eq(chat.id)
    end

    it 'with content missing' do
      post "/chats/#{chat.id}/messages",
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { message: { content: '' }, format: :json }

        expect(response.status).to eq(422)

        expect(json['content']).to eq(["can't be blank"])
    end
  end

  context 'get all messages' do
    it 'without token' do
      get "/chats/#{chat.id}/messages"
      expect(response.status).to eq(401)
    end

    it 'without access rights' do
      john = FactoryGirl.create(:user)
      get "/chats/#{chat.id}/messages",
        headers: {'Authorization': "Token token=#{john.auth_token}"}

      expect(response.status).to eq(403)
    end

    it 'successfully' do
      FactoryGirl.create_list(:message, 10, user: user, chat: chat)
      get "/chats/#{chat.id}/messages", params: { format: :json },
        headers: {'Authorization': "Token token=#{user.auth_token}"}

      expect(response.status).to eq(200)

      expect(json.size).to eq(10)
    end
  end

  context 'get unread messages' do
    it 'without token' do
      get "/chats/#{chat.id}/messages/unread"
      expect(response.status).to eq(401)
    end

    it 'without access rights' do
      john = FactoryGirl.create(:user)
      get "/chats/#{chat.id}/messages/unread",
        headers: {'Authorization': "Token token=#{john.auth_token}"}

      expect(response.status).to eq(403)
    end

    it 'successfully' do
      FactoryGirl.create_list(:message, 10, user: user_2, chat: chat)
      get "/chats/#{chat.id}/messages/unread", params: { format: :json },
        headers: {'Authorization': "Token token=#{user.auth_token}"}

      expect(response.status).to eq(200)

      expect(json.size).to eq(10)
    end
  end
end
