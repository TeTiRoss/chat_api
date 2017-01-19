require 'rails_helper'

describe 'Chats API' do
  let!(:user) { FactoryGirl.create(:user) }

  context 'create chat' do
    it 'without token' do
      post '/chats'
      expect(response.status).to eq(401)
    end

    it 'with all required fields' do
      user_2 = FactoryGirl.create(:user)
      post '/chats',
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { chat: { name: 'Football', user_ids: [user_2.id] },
          format: :json }

      expect(response.status).to eq(201)

      expect(json['chat']['name']).to eq('Football')
      expect(json['chat']['user_ids']).to eq([user_2.id, user.id])
    end

    it 'with empty fields' do
      post '/chats',
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { chat: { name: '', user_ids: [] },
          format: :json }

      expect(response.status).to eq(422)

      expect(json['name']).to eq(["can't be blank"])
      expect(json['users']).to eq(['is too short (minimum is 2 characters)'])
    end

    it 'with already existing name' do
      user_2 = FactoryGirl.create(:user)
      FactoryGirl.create(:chat, name: 'Cats', users: [user, user_2])
      post '/chats',
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { chat: { name: 'Cats', user_ids: [] },
          format: :json }

      expect(response.status).to eq(422)

      expect(json['name']).to eq(['has already been taken'])
    end

    it 'with no users in params' do
      post '/chats',
        headers: {'Authorization': "Token token=#{user.auth_token}"},
        params: { chat: { name: 'Cats', user_ids: [] },
          format: :json }

      expect(response.status).to eq(422)

      expect(json['users']).to eq(['is too short (minimum is 2 characters)'])
    end
  end

  context 'existing chat' do
    let!(:user_2) { FactoryGirl.create(:user) }
    let!(:chat) { FactoryGirl.create(:chat, users: [user, user_2]) }

    context 'edit' do
      it 'without token' do
        put "/chats/#{chat.id}"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        put "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'change name' do
        put "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{user.auth_token}"},
          params: { chat: { name: 'New name' }, format: :json }

        expect(response.status).to eq(200)
        expect(json['chat']['name']).to eq('New name')
      end

      it 'change users' do
        new_user = FactoryGirl.create(:user)
        put "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{user.auth_token}"},
          params: { chat: { user_ids: [new_user.id] }, format: :json }

        expect(response.status).to eq(200)
        expect(json['chat']['user_ids']).to eq([user.id, new_user.id])
      end
    end

    context 'read' do
      it 'without token' do
        put "/chats/#{chat.id}/read"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        put "/chats/#{chat.id}/read",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'successfully' do
        put "/chats/#{chat.id}/read",
          headers: {'Authorization': "Token token=#{user.auth_token}"}
        expect(response.status).to eq(200)
      end
    end

    context 'show' do
      it 'without token' do
        get "/chats/#{chat.id}"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        get "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'successfully' do
        get "/chats/#{chat.id}", params: { format: :json },
          headers: {'Authorization': "Token token=#{user.auth_token}"}
        expect(response.status).to eq(200)

        expect(json['chat']['user_ids']).to eq([user.id, user_2.id])
        expect(json['chat']['name']).to eq(chat.name)
      end
    end

    context 'delete' do
      it 'without token' do
        delete "/chats/#{chat.id}"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        delete "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'successfully' do
        delete "/chats/#{chat.id}",
          headers: {'Authorization': "Token token=#{user.auth_token}"}
        expect(response.status).to eq(204)
      end
    end

    context 'get all' do
      it 'without token' do
        get '/chats'
        expect(response.status).to eq(401)
      end

      it 'successfully' do
        FactoryGirl.create_list(:chat, 10, users: [user, user_2])
        get '/chats', params: { format: :json },
          headers: {'Authorization': "Token token=#{user.auth_token}"}

        expect(response.status).to eq(200)

        expect(json.size).to eq(11)
      end
    end
  end
end
