class SessionsController < ApplicationController

  skip_before_action :authenticate_user!

  def create
    @user = User.find_by(name: session_params[:name])
    if @user && @user.authenticate(session_params[:password])
      render 'user', status: :ok
    else
      render json: { errors: 'Invalid name or password' },
        status: :unprocessable_entity
    end
  end

  private
    def session_params
      params.require(:user).permit(:name, :password)
    end
end
