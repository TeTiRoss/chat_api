class ApplicationController < ActionController::API
  before_action :check_chat_user

  private

    def current_user
      User.first
    end

    def check_chat_user
      chat = params[:chat_id] ? Chat.find(params[:chat_id]) : Chat.find(params[:id])
      unless chat.users.include?(current_user)
        render json: { errors: 'You dont have access to this chat' },
          status: :forbidden
      end
    end
end
