class UsersController < ApplicationController
  
  def new
    #Create empty user
    @user = User.new
  end

  def show
    #add code to show users
  end

  def create
    @user = User.new(user_params)
    #byebug
    if(@user.save)
      log_in(@user)
      redirect_to @user
    else
      render 'new'
    end
  end
  
  private
    def user_params
      return params.require(:user).permit(:name, :email, :password, :password_confirmation)
      #require() marks what params are required
      #permit() limits which parameters can be passed in
    end
end
