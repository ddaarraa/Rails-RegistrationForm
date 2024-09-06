class RegistrationsController < ApplicationController
  \
  def index
    @subjects = ['Physics', 'Maths', 'Coding', 'Mechanicsm']
    @user = User.new

  end
  def create
    @user = User.new(user_params)

    if @user.save
      # flash[:notice] = 'Account Create Successfully'
      redirect_to root_path, notice: "User was successfully created."
    else
      # flash[:alert] = "something wrong"
      @subjects = ['Physics', 'Maths', 'Coding', 'Mechanicsm']

      render :index
    end

  end


  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email,:phonenumber, :birthday, :gender, :subject)
  end

end
