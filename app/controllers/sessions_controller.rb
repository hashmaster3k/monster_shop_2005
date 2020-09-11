class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to '/profile' if user.user?
        redirect_to '/merchant/dashboard' if user.merchant?
        redirect_to '/admin/dashboard' if user.admin?
        flash[:success] = "Logged in as #{user.name}"
      else
        flash.now[:error] = "Credentials are incorrect"
        render :new
      end
    else
      flash.now[:error] = "Credentials are incorrect"
      render :new
    end
  end

  def destroy
    cart.contents.clear
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to '/login'
  end
end
