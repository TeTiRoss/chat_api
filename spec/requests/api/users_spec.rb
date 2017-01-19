require 'rails_helper'

describe 'Users API' do
  context 'create user' do
    it 'with all required fields' do
      post '/users',
        params: { format: :json, user: { name: 'Ross', password: '12345678' } }

      expect(response.status).to eq(201)

      expect(json['user']['name']).to eq('Ross')
    end

    it 'with not unique name' do
      FactoryGirl.create(:user, name: 'Mike')

      post '/users', params: { user: { name: 'Mike', password: '12345678' } }

      expect(response.status).to eq(422)

      expect(json['name']).to eq(['has already been taken'])
    end

    it 'with not enough password length' do
      post '/users', params: { user: { name: 'Mike', password: '1234' } }

      expect(response.status).to eq(422)

      expect(json['password']).to eq(['is too short (minimum is 8 characters)'])
    end

    it 'with blank name and password' do
      post '/users', params: { user: { name: '', password: '' } }

      expect(response.status).to eq(422)

      expect(json['name']).to eq(["can't be blank"])
      expect(json['password']).to eq(["can't be blank"])
    end
  end

  context 'show info with authorize user' do
    let!(:user) { FactoryGirl.create(:user) }

    it 'about all users' do
      FactoryGirl.create_list(:user, 10)
      get '/users', params: { format: :json },
        headers: {'Authorization': "Token token=#{user.auth_token}"}

      expect(response.status).to eq(200)

      expect(json.size).to eq(11)
      expect(json[0]['user']['auth_token']).to eq(nil)
    end

    it 'about certain user' do
      user = FactoryGirl.create(:user, name: 'Oliver')

      get "/users/#{user.id}", params: { format: :json },
        headers: {'Authorization': "Token token=#{user.auth_token}"}

      expect(response.status).to eq(200)

      expect(json['user']['name']).to eq('Oliver')
      expect(json['user']['auth_token']).to eq(nil)
    end
  end

  context 'show info without authorize user' do
    it 'about all users' do
      get '/users'

      expect(response.status).to eq(401)
    end

    it 'about certain user' do
      user = FactoryGirl.create(:user, name: 'Oliver')

      get "/users/#{user.id}", params: { format: :json }

      expect(response.status).to eq(401)
    end
  end

  context 'existing user' do
    let!(:user) { FactoryGirl.create(:user) }

    context 'edit' do
      it 'without token' do
        put "/users/#{user.id}"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        put "/users/#{user.id}",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'successfully' do
        put "/users/#{user.id}",
          params: { user: { name: 'Nick' }, format: :json },
          headers: {'Authorization': "Token token=#{user.auth_token}"}

        expect(response.status).to eq(200)

        expect(json['user']['name']).to eq('Nick')
      end
    end

    context 'delete' do
      it 'without token' do
        delete "/users/#{user.id}"
        expect(response.status).to eq(401)
      end

      it 'without access rights' do
        john = FactoryGirl.create(:user)
        delete "/users/#{user.id}",
          headers: {'Authorization': "Token token=#{john.auth_token}"}

        expect(response.status).to eq(403)
      end

      it 'successfully' do
        delete "/users/#{user.id}",
          headers: {'Authorization': "Token token=#{user.auth_token}"}

        expect(response.status).to eq(204)
      end
    end
  end
end
