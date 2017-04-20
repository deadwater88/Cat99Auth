class SessionsController < ApplicationController

  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params[:user_name], user_params[:password])
    if @user
      login
      redirect_to cats_url
    else
      flash.now[:error] = ["Invalid Credentials"]
      render :new
    end
  end

  def destroy
    if current_user
      current_user.reset_session_token!
    end
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end

  # def logged_out?
  #   if current_user
  #     redirect_to cats_url
  #   end
  # end
end
