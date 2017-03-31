require 'openssl'
#The User Controller is in charge of the logic behind the users
#It allows for users to be created, viewed, deleted, updated, edited, and listed
class UsersController < ApplicationController
  #Calls the "before_action" method before the following actions. Actions only take place if the 
  #methods return true.
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :show]
  before_action :correct_user,   only: [:edit, :update, :show]
  before_action :admin_user,     only: :destroy
  
  def new
    #Create empty user
    @user = User.new
  end
  
  #Gets all the users, which is then displayed by the index view
  def index
    @users = User.all
  end
  
  #Calls the show view, which displays user account information
  def show
     @user = User.find_by(id: params[:id])
  end

  #Creates a user
  def create
    @user = User.new(user_params)
    
    #If the user creation is successful, the user will automatically be saved. Creation is deemed successful
    #if the inputed parameters are deemed legal by the model validations (done in the User model)
    if(@user.save)
      log_in(@user)
      flash[:success] = "Welcome to CloudShare!"
      redirect_to @user
    else
      flash.now[:danger] = "Error. Could not create user!"
      render 'new'
    end
  end
  
  #Calls on the edit view to allow a user to edit their account details
  def edit
    @user = User.find(params[:id])
  end
  
  #Update user account information
  def update
     @user = User.find(params[:id])
     
     if( @user.update_attributes(user_params))
       flash[:success] = "Sucessfully updated account information"
       redirect_to @user
     else
       render "edit"
     end
  end
  
  #Deletes the user
  def destroy
    target = User.find(params[:id])
    #Admins can not delete other admins
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
  
  #Security measure to stop unchecked data coming from the web.
  private
    def user_params
      other_param = params.require(:user).permit(:name, :email, :password, :password_confirmation)
      keypair_param = {}
      
      if other_param[:password] != nil
        if other_param[:password].length >= 4
          keypair_param = create_keypair(other_param[:password])
        end
      end
      #require() marks what params are required
      #permit() limits which parameters can be passed in
      return keypair_param.merge(other_param)
    end
    
end
