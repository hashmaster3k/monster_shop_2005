class UsersController < ApplicationController

  def new
  end

  def create
    @user = User.new(user_params)
    if params[:password] == params[:confirm_password] && @user.save
      session[:user_id] = @user.id
      flash[:success] = "You are now registered and logged in"
      redirect_to '/profile'
    elsif params[:password] != params[:confirm_password]
      flash[:alert] = "Passwords do not match"
      render :new
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :new
    end
  end

  def show
    render file: "/public/404" if !current_user
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
