class Admin::UsersController < ApplicationController

  before_action :only_admin
  
  def index
    @users = User.all
  end

  private

  def only_admin
    unless current_user.admin
      flash[:alert] = "Admin only"
      redirect_to root_path
    end
  end
end
