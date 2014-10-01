class Admin::UsersController < ApplicationController

  before_action :only_admin
  
  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "New user #{@user.firstname} created successfully."
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "#{@user.firstname}'s account updated successfully."
    else
      render :new
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path, notice: "#{@user.firstname}'s account has been destroyed."
  end

  def switch_to
    user = User.find(params[:user_id])

    if user.admin
      redirect_to admin_users_path, notice: "You can't switch into admin accounts"
    else
      session[:remember_admin] = session[:user_id]
      session[:user_id] = user.id
      redirect_to movies_path, notice: "Switched into #{user.firstname}'s account"
    end
  end

  def switch_back
    user = User.find(session[:remember_admin])
    session[:user_id] = user.id
    session[:remember_admin] = nil

    redirect_to movies_path, notice: "Switched back to admin account, #{user.firstname}"
  end

  private

  def only_admin
    unless current_user.admin || switched_from_admin?
      flash[:alert] = "Admin only"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :admin, :password, :password_confirmation)
  end
end
