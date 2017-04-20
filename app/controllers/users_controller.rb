class UsersController < ApplicationController

  before_action :logged_out?, only: [:destroy]

  def new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      login
      redirect_to cats_url
    else
      flash[:error] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end

  private
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
  
  def logged_out?
    redirect_to cats_url if current_user
  end

end
