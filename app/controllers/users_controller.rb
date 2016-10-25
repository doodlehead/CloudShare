class UsersController < ApplicationController
  
  def new
    #Create empty user
    @user = User.new
  end

  def show
  end

  def create
    #@user = User.new(name: params[:name], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
  end
end
