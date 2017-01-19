class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user!

  protected

    def authenticate_user!
      authenticate_or_request_with_http_token do |token, options|
        @current_user = User.find_by(auth_token: token)
      end
    end

    def validate_access
      unless !!@chat.chats_users.find_by(user_id: @current_user.id)
        head :forbidden
      end
    end
end
