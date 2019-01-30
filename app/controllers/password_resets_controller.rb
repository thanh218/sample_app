class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "passreset"
      redirect_to root_url
    else
      flash.now[:danger] = t "foundemail"
      render :new
    end
  end

  def update
    if params[:user][:password].empty?                  
      @user.errors.add(:password, t("cannot_be_empty"))
      render :edit
    elsif @user.update user_params        
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = t "content3"
      redirect_to @user
    else
      render :edit                                  
    end
  end

  def edit; end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
  end

  def valid_user
    return if @user&.activated? && @user.authenticated?(:reset, params[:id]) 
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "content4"
    redirect_to new_password_reset_url
  end
end
