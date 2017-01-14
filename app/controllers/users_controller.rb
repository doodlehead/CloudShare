class UsersController < ApplicationController
  #Calls the "before_action" method before the following actions
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: :destroy
  
  def new
    #Create empty user
    @user = User.new
  end
  
  def index
    @users = User.all
  end
  
  def show
     @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.new(user_params)
    #byebug
    if(@user.save)
      log_in(@user)
      flash[:success] = "Welcome to CloudShare!"
      redirect_to @user
    else
      flash.now[:danger] = "Error. Could not create user!"
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
  
  def destroy
    target = User.find(params[:id])
    if(target.admin?)
      flash[:danger] = "Cannot delete admin account"
      redirect_to user_path(target)
    else
      @asset = target.assets.all
      
      #Delete all of the user's files
      @asset.each do |asset|
        asset.destroy
      end
      
      target.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end
  
  private
    def user_params
      return params.require(:user).permit(:name, :email, :password, :password_confirmation)
      #require() marks what params are required
      #permit() limits which parameters can be passed in
    end
    
end
