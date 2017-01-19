require 'rails_helper'

describe 'Authentication API' do
  let!(:user) { FactoryGirl.create(:user) }

  it 'get auth token' do
    post '/sessions',
      params: { user: { name: user.name, password: user.password },
        format: :json }

    expect(response.status).to eq(200)

    expect(json['user']['token']).to be_present
  end

  context 'access data' do
    it 'with token' do
      get '/users', params: { format: :json },
        headers: {'Authorization': "Token token=#{user.auth_token}"}

      expect(response.status).to eq(200)
    end

    it 'without token' do
      get '/users', params: { format: :json }

      expect(response.status).to eq(401)
    end
  end
end
