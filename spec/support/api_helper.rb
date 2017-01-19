module ApiHelper
  def get_token(user)
    user = FactoryGirl.create(:user)
    post '/sessions',
      params: { user: { name: user.name, password: user.password },
        format: :json }

    json['user']['token']
  end

  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
