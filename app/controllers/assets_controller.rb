class AssetsController < ApplicationController
  before_action :logged_in_user, only: [:set_asset, :index, :edit, :get, :show, :new, :create,:update, :destroy, :sharing, :share_index, :share, :unshare, :shared_files]
  before_action :set_asset, only: [:show, :get, :edit, :update, :destroy]
  before_action :admin_user, only: [:update, :edit]
  before_action :has_storage, only: [:create]
  # GET /assets
  # GET /assets.json
  def index
    @assets = current_user.assets.all
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end
  
  def sharing 
  end 
  #Displays users that an asset has been shared to
  def share_index
    @asset = Asset.find(params[:id])
    str = @asset.shared_with.to_s
    @shared_to = str.split(",")
  end
  
  def share
    @asset = Asset.find(params[:id])
    other_user_id = User.find_by(share_params).id
    #remember to catch error
    shared_user = User.find_by(id: other_user_id)
    #For some reason, @asset.update_attribute was not working, but with a local variable, it does
    the_asset = @asset
    
    if shareable?(other_user_id)
      asset_update = ""
      user_update = ""
      
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
    
      shared_user.update_attribute(:shared_files, user_update)
      the_asset.update_attribute(:shared_with, asset_update)
    end    
  end
  
  def unshare
    the_asset = Asset.find(params[:id])
    shared_user = User.find_by(id: params[:sId].to_i)
    
    user_update = shared_user.shared_files.split(",").delete(params[:id])
    asset_update = the_asset.shared_with.split(",").delete(:sId)
    
    shared_user.update_attribute(:shared_files, user_update)
    the_asset.update_attribute(:shared_with, asset_update)    
  end
  
  #Crashes if no shared files are present
  #Later, make shared_files check to see if the asset lists the user, for added security
  def shared_files
    if current_user.shared_files
      @assets = list_shared_assets
      puts @assets.empty?
      puts @assets.length
    end
  end
  
  def get
    send_file @asset.asset.path,
      :filename => @asset.asset.original_filename,
      :type => @asset.asset.content_type,
      :disposition => 'attachment'
  end
  # GET /assets/new
  def new
    @asset = current_user.assets.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = current_user.assets.new(asset_params)
    
    if(@asset.asset.size + calculate_storage(current_user) > (1024*1024*5))
      flash[:danger] = "You do not have enough storage to upload this file! Please delete some files to free up space."
      redirect_to assets_path
    else
      respond_to do |format|
        if @asset.save
          format.html { redirect_to @asset, notice: 'Asset was successfully created.' }
          format.json { render :show, status: :created, location: @asset }
        else
          format.html { render :new }
          format.json { render json: @asset.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /assets/1
  # PATCH/PUT /assets/1.json
  def update
    respond_to do |format|
      if @asset.update(asset_params)
        format.html { redirect_to @asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @asset }
      else
        format.html { render :edit }
        format.json { render json: @asset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.json
  def destroy
    @asset.destroy
    respond_to do |format|
      format.html { redirect_to assets_url, notice: 'Asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = current_user.assets.find_by(id: params[:id])
      if(@asset == nil)
        @assets = list_shared_assets
        
        0.upto(@assets.length-1) do |x|
          if(params[:id].to_i == @assets[x].id.to_i)
            @asset = @assets[x]
          end
        end
      end
      if(@asset == nil)
        flash[:danger] = "File does not exist!"
        redirect_to assets_path
      end
    end

    # Never trust parameters from the s.cary internet, only allow the white list through.
    def asset_params
      #byebug
      params.require(:asset).permit(:user_id, :asset)
    end
    
    def share_params
      params.require(:asset).permit(:email)
    end
    
    def has_storage
      #10 MB
      if(calculate_storage(current_user) > (1024*1024*5))
        flash[:danger] = "You are over the storage limit! Please delete some files to upload more."
        redirect_to assets_url
      end
    end
    
    def list_shared_assets
      str = current_user.shared_files.to_s
      a = str.split(",")
      @assets = []
      puts "in list_shared_params"
      puts a.length
      puts a
      0.upto(a.length-1) do |x|
        aId = a[x]
        @assets << Asset.find_by_id(aId)
      end
        @assets
    end
    
end
