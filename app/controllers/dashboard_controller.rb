class DashboardController < ApplicationController
  def index
    @users = User.all
  end

  def delete
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User #{params[:id]} deleted successfully"
    else
      flash[:alert] = "There was an error deleting the user"
    end
    redirect_to dashboard_path
  end

end
