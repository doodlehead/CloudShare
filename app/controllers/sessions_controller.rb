class SessionsController < ApplicationController
  def new
    #byebug0
    #@session = Session.new
  end
  
  def create
    #render 'new'
    
    #Try to find the user in the database
    user = User.find_by(email: params[:session][:email].downcase) #Why is there a sessions hash?...
    if user && user.authenticate(params[:session][:password])
      log_in(user) #store id in cache
      redirect_to user_url(user)
    else
      #show errors
      #refresh the page
      render 'new'
    end
    
  end
end
