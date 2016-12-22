class AssetsController < ApplicationController
  before_action :logged_in_user, only: [:set_asset, :index, :edit, :get, :show, :new, :create,:update, :destroy]
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
        flash[:danger] = "File does not exist!"
        redirect_to assets_path
      end
    end

    # Never trust parameters from the s.cary internet, only allow the white list through.
    def asset_params
      #byebug
      params.require(:asset).permit(:user_id, :asset)
    end
    
    def has_storage
      #10 MB
      if(calculate_storage(current_user) > (1024*1024*5))
        flash[:danger] = "You are over the storage limit! Please delete some files to upload more."
        redirect_to assets_url
      end
    end
    
end
