class ChatsController < ApplicationController

  before_action :set_chat, only: [:read, :show, :update, :destroy]
  before_action :validate_access, except: [:index, :create]

  def index
    @chats = @current_user.chats
  end

  def show
  end

  def create
    update_params_with_current_user
    @chat = Chat.new(chat_params)
    if @chat.save
      render :show, status: :created
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def update
    update_params_with_current_user
    if @chat.update_attributes(chat_params)
      render :show
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @chat.destroy
  end

  def read
    @chat.set_as_read(@current_user)
    head :ok
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:name,  user_ids: [])
    end

    def update_params_with_current_user
      params[:chat][:user_ids] << @current_user.id if params[:chat][:user_ids]
    end
end
