class UsersController < ApplicationController

  before_action :set_user, only: [:show, :update, :destroy]
  before_action :validate_edit_access, only: [:update, :destroy]
  skip_before_action :authenticate_user!, only: [:create]

  def index
    @users = User.all
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render :show, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render :show
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def validate_edit_access
      head :forbidden unless @current_user == @user
    end
end
