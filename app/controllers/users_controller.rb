class UsersController < ApplicationController
  #Calls the logged_in_user method before the following actions
  before_action :logged_in_user, only: [:edit, :update]
  
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
  
  def edit
    #Relocate the user
    @user = User.find(params[:id])
  end
  
  def update
     @user = User.find(params[:id])
     
     if( @user.update_attributes(user_params))
       flash[:success] = "Sucessfully updated account information"
       #handle update...
       redirect_to @user
     else
       render "edit"
     end
  end
  
  private
    def user_params
      return params.require(:user).permit(:name, :email, :password, :password_confirmation)
      #require() marks what params are required
      #permit() limits which parameters can be passed in
    end
    
    def logged_in_user
      unless logged_in?
        redirect_to root_url
      end
    end
end
