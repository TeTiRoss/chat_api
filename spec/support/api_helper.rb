module ApiHelper
  def get_token(user)
    post '/sessions', params: { name: user.name, password: user.password }

    json = JSON.parse(response.body)

    json[:user][:token]
  end

  def json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request
end
