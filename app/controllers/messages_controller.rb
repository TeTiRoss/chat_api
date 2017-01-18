class MessagesController < ApplicationController

  before_action :set_chat

  def index
    @chat.clear_unread_messages(@current_user)
    @messages = @chat.messages
  end

  def create
    @message = @chat.messages.new(message_params.merge(user: @current_user))
    if @message.save
      render :show, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private

    def set_chat
      @chat = Chat.find(params[:chat_id])
    end

    def message_params
      params.require(:message).permit(:content, :chat_id, :user_id)
    end
end
