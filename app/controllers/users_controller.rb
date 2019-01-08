class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy correct_user)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.user_number
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t ".statusmail"
      redirect_to root_url
    else
      flash[:notice] = t ".content2"
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t ".content1"
      redirect_to @user
    else
      flash[:ranger] = t ".content2"
      render :edit
    end
  end

  def destroy
    if @user&.destroy
    flash[:success] = t ".content4"
    else
    flash[:danger] = t ".content2"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".title4"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
  
  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t ".content1"
    redirect_to home_path
  end
end
