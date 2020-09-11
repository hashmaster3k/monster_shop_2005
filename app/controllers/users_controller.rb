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
    @user = current_user
    render file: "/public/404" if !current_user
  end

  def edit
    @user = current_user
  end

  def update
    if params[:password]
      if params[:password] == params[:confirm_password]
        current_user.update_attribute(:password, params[:password])
        flash[:success] = "Profile Password Updated"
        redirect_to '/profile'
      else
        flash[:error] = "Passwords do not match"
        redirect_to '/profile/edit/password'
      end
    else
      @user = current_user
      @user.update_attribute(:name, user_params[:name])
      @user.update_attribute(:address, user_params[:address])
      @user.update_attribute(:city, user_params[:city])
      @user.update_attribute(:state, user_params[:state])
      @user.update_attribute(:zip, user_params[:zip])
      @user.update_attribute(:email, user_params[:email])
      redirect_to "/profile"
      flash[:success] = "Profile Information Updated"
    end
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
