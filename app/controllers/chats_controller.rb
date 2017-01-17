class ChatsController < ApplicationController

  before_action :set_chat, only: [:show, :update, :destroy]

  def index
    @chats = Chat.all
  end

  def show
  end

  def create
    @chat = Chat.new(chat_params)
    if @chat.save
      render :show, status: :created, location: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def update
    if @chat.update_attributes(chat_params)
      render :show
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:name,  user_ids: [])
    end
end
