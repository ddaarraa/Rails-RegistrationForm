class DashboardController < ApplicationController
  def index
    @users = User.all
  end

  def delete
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User No.#{params[:id]} deleted successfully"
    else
      flash[:alert] = "There was an error deleting the user"
    end
    redirect_to root_path
  end

  def update
    user_id = params[:id]
    @subjects = ['Physics', 'Maths', 'Coding']
    @user = User.find(user_id)
  end
  def update_action
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to root_path
    else
      flash[:alert] = "There was an error updating the user."
      render :update
    end
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email,:phonenumber, :birthday, :gender, :subject)
  end

end
