#This controller is in charge of the logic behind keeping a user logged in.
#It enables a user to log in, and log out.
#Much of the methods used here can be found in the SessionsHelper module.
class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    #Try to find the user in the database
    user = User.find_by(email: params[:session][:email].downcase) 
    if user && user.authenticate(params[:session][:password])
      log_in(user) #store id in cache
      redirect_to user_url(user)
    else
      flash.now[:danger] = "Invalid username or password"
      #refresh the page
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    flash[:success] = "Successfully logged out" if !logged_in?
    redirect_to root_url
  end
  
  #REALLY GOOD reference doc: http://guides.rubyonrails.org/security.html
end
