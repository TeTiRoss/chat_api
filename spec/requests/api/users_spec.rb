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
end
