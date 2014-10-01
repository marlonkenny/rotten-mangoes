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
    
  end

  private

  def only_admin
    unless current_user.admin
      flash[:alert] = "Admin only"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :admin, :password, :password_confirmation)
  end
end
