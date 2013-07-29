class ProfilesController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = @current_user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
    else
      render action: "new"
    end
  end

  def update
    if @current_user.update(user_params)
      redirect_to @current_user
    else
      render action: "edit"
    end
  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
