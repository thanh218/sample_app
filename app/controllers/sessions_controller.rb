class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user&.authenticate params[:session][:password]
      if user.activated?
        user_activated user
      else
        flash[:warning] = t ".content"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "erro_account"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private 

  def user_activated user
    log_in user
    params[:session][:remember_me] == Settings.remember ? remember(user) : forget(user)
    redirect_back_or user
  end
end
