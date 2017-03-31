#The asset controller is responsible for controlling all the logic behind the assets–our file class.
#The controller allows one to upload, download, view, and delete their files, as well as sharing/unsharing them.
#Much of the methods called here can be found in the AssetsHelper and the SessionsHelper modules.
class AssetsController < ApplicationController
  #Calls the "before_action" method before the following actions. If the methods return true the following
  #actions will take place
  before_action :logged_in_user, only: [:set_asset, :index, :edit, :get, :show, :new, :create,:update, :destroy, :sharing, :share_index, :share, :unshare, :shared_files]
  before_action :set_asset, only: [:show, :get, :edit, :update, :destroy, :enter_password, :password_input, :enter_password_shared, :password_input_shared]
  before_action :admin_user, only: [:update, :edit]
  before_action :has_storage, only: [:create]
  
  # GET /assets
  # GET /assets.json
  #Shows the index view, which displays all the assets the user owns
  def index
    assets = current_user.assets.all
    
    assets.each do |asset|
      if asset.tempfile == true
        asset.destroy
      end
    end
    
    @assets = current_user.assets.all
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end
  
    # GET /assets/new
  def new
    @asset = current_user.assets.new
  end

  # POST /assets
  # POST /assets.json
  #Creates and attemps to save an Asset
  def create
    @asset = current_user.assets.new(asset_params)
    
    #Check if the current user has enough storage to upload the asset
    if(@asset.asset.size + calculate_storage(current_user) > (1024*1024*5))
      flash[:danger] = "You do not have enough storage to upload this file! Please delete some files to free up space."
      redirect_to assets_path
    else
      
      #Check if the file saves sucessfully
      if @asset.save
        keyHash = symmetric_encrypt(@asset)
        
        #Key has to be created after asset creation, else asset has no id.
        keyHash = keyHash.merge(asset_id: @asset.id)
        Key.create(keyHash)
        
        flash[:success] = 'File was successfully uploaded'
        redirect_to assets_path
      else
        #Show error message if the save fails
        flash[:danger] = 'Error! File could not be uploaded'
        redirect_to assets_path
      end
    end
  end
  
  # DELETE /assets/1
  # DELETE /assets/1.json
  #Deletes the file from the database
  def destroy
    @asset = Asset.find(params[:id])
    #Destroys key corresponding to the asset
    keys = Key.all
    
    keys.each do |key| 
      if(key.asset_id == @asset.id)
        key.destroy
      end
    end    
    #Deletes the asset id from its recipients' shared_files column, as it will no longer exist
    sharedList = @asset.shared_with.split(",")
    0.upto(sharedList.length-1) do |x|
      
      user_update = User.find(sharedList[x].to_i).shared_files.split(",")
      user_update.delete(@asset.id.to_s)  
      user_update = user_update.join(",")
      
      #See lines 91-92
      if user_update.length != 0
        user_update = user_update << ","
      end
      
      User.find(sharedList[x].to_i).update_attribute(:shared_files, user_update)
    end
    @asset.destroy
    flash[:success] = "Successfully deleted file"
    redirect_to assets_path
  end
  
  #NOTE: in the methods related to sharing, you will see a lot of string manipulation (primarily .split() and .join(). .split() converts a string to an array, and .join() an array to a string).
  #Sharing works by creating an array that is an assets attribute, listing users that may view it, while created an array on the recipients side, that is a user attribute, listing assets that 
  #the user is a recipient of. Unfortuantely, SQlite3 does not support arrays as a database column type. As a workaround, the "arrays" are converted into strings, and are converted back into 
  #arrays when their data is needed.
  
  #Displays page that takes user input, determining who the user wants to share to
  def sharing 
  end 
  
  #Displays users that an asset has been shared to
  def share_index
    @asset = Asset.find(params[:id])
    str = @asset.shared_with.to_s
    @shared_to = str.split(",")
  end
  
  #Shares a file with another user
  def share
    @asset = Asset.find(params[:id])
    #Checks to see if the entered in email address is valid
    if(User.find_by(email: share_params[:email]) == nil)
      flash[:danger] = "User doesn't exist"
      redirect_to sharing_asset_path
    else
      other_user_id = User.find_by(email: share_params[:email]).id
      shared_user = User.find_by(id: other_user_id)
      #For some reason, @asset.update_attribute was not working, but with a local variable, it does
      the_asset = @asset
      
      #shareable? is a boolean (located in helper module). It checks to see if the given user can be shared to
      if shareable?(other_user_id)
        
        if @asset.shared_with == nil 
          asset_update = other_user_id.to_s << ","
        else
          asset_update = @asset.shared_with.to_s << other_user_id.to_s << ","
        end
        
        if shared_user.shared_files == nil
          user_update = @asset.id.to_s << ","
        else
          user_update = shared_user.shared_files << @asset.id.to_s << ","
        end
        
        #Updates the database
        shared_user.update_attribute(:shared_files, user_update)
        the_asset.update_attribute(:shared_with, asset_update)
        
        password = share_params[:password]
        share_key(other_user_id,@asset,password)
        
        redirect_to assets_path
      else
        flash[:danger] = "Could not share with the user"
        redirect_to sharing_asset_path
      end
    end
  end
  
  #Allows a user to remove viewing privledges from someone they previously shared to
  def unshare
    the_asset = Asset.find(params[:id])
    shared_user = User.find_by(id: params[:sId].to_i)
   
    user_update = shared_user.shared_files.split(",")
    user_update.delete(params[:id].to_s)
    user_update = user_update.join(",")
    
    asset_update = the_asset.shared_with.split(",")
    asset_update.delete(params[:sId].to_s)
    asset_update = asset_update.join(",")
    
    keys = Key.all
    
    keys.each do |key| 
      if(key.asset_id == @asset.id && key.owner_id == shared_user.id)
        key.destroy
      end
    end    
    
    #Due to a quirk of ruby, str = ",1," , str.split(",") will return ["","1"]. "".to_i will then return 0. This causes other processes related to sharing to freak out,
    #as no asset will ever exist with the id 0. This block fixes that issue. A similar block is also used in the destroy method.
    if user_update.length != 0
      user_update = user_update << ","
    end
    if asset_update.length != 0
      asset_update = asset_update << ","
    end
    
    #Updates database
    shared_user.update_attribute(:shared_files, user_update)
    the_asset.update_attribute(:shared_with, asset_update)
    
    flash[:warning] = "File unshared"
    redirect_to share_index_asset_path
  end
  
  #Shows the files that are shared to the user.
  def shared_files
    if current_user.shared_files
      @assets = list_shared_assets
      
      assets = current_user.assets.all

      assets.each do |asset|
        if asset.tempfile == true
          asset.destroy
        end
      end
    end
  end
  
  #Sends a request to the browser to download an asset
  def get(password, shared)
    if current_user.authenticate(password)
      tempAsset = symmetric_decrypt(@asset, password)
      send_file tempAsset.asset.path,
        :filename => @asset.asset.original_filename,
        :type => @asset.asset.content_type,
        :disposition => 'attachment' 
    else
      flash[:danger] = 'Error! Password is incorrect!'
      if shared == false
        redirect_to enter_password_asset_path
      else
        redirect_to enter_password_shared_asset_path
      end
    end
  end
  
  #Dipslays page to enter a password for downloading
  def enter_password
  end

  #Enter_password and enter_password_shared post here
  def password_input
    if password_params != nil
      password = password_params[:password]
      shared = false
      get(password, shared)      
    end
  end
    
  #Only difference from enter_password, is that it redirects shared_files
  def enter_password_shared
  end
  
  #Like password_input, but for shared files(sort of like above block)
  def password_input_shared
    if password_params != nil
      password = password_params[:password]
      shared = true
      get(password, shared)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = current_user.assets.find_by(id: params[:id])
     
      # If the file the user is looking for isn't owned by them, but is shared to them, the subsequent 
      # code finds it.      
      if(@asset == nil)
        @assets = list_shared_assets
        
        0.upto(@assets.length-1) do |x|
          if(params[:id].to_i == @assets[x].id.to_i)
            @asset = @assets[x]
          end
        end
      end
      
      # If the requested file was neither owned by the user nor shared to them, this code executes.
      if(@asset == nil)
        flash[:danger] = "File does not exist!"
        redirect_to assets_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def asset_params
      params.require(:asset).permit(:user_id, :asset)
    end
    
    # Allows only a white list of parameters through, for security reasons.
    def share_params
      params.require(:asset).permit(:email, :password)
    end
    
    def password_params
      params.require(:asset).permit(:password)
    end
    # Checks to see if the user has adequate storage for their upload.
    def has_storage
      #10 MB
      if(calculate_storage(current_user) > (1024*1024*5))
        flash[:danger] = "You are over the storage limit! Please delete some files to upload more."
        redirect_to assets_url
      end
    end
    
    # Returns a list of assets that are shared to the current user
    def list_shared_assets
      str = current_user.shared_files.to_s
      a = str.split(",")
      @assets = []
      
      0.upto(a.length-1) do |x|
        aId = a[x].to_i
        @assets << Asset.find(aId)
      end
      
      @assets  
    end
    
end
