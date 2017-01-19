class MessagesController < ApplicationController

  before_action :set_chat, :validate_access

  def index
    @messages = @chat.messages
    @chat.set_as_read(@current_user)
    render 'messages'
  end

  def create
    @message = @chat.messages.new(message_params.merge(user: @current_user))
    if @message.save
      render :show, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def unread
    @messages = @chat.messages.unread_by(@current_user)
    render 'messages'
  end

  private

    def set_chat
      @chat = Chat.find(params[:chat_id])
    end

    def message_params
      params.require(:message).permit(:content, :chat_id, :user_id)
    end
end
