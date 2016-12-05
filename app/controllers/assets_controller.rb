class AssetsController < ApplicationController
 
  #before_action :correct_user?
  # GET /assets
  # GET /assets.json
  def index
    @assets = Asset.all
  end

  # GET /assets/1
  # GET /assets/1.json
  def show
  end

  # GET /assets/new
  #Creates empty asset
  def new
    @asset = Asset.new
  end

  # GET /assets/1/edit
  def edit
  end

  # POST /assets
  # POST /assets.json
  def create
    @asset = Asset.new(asset_params)
    if(@asset.save)
       flash[:success] = "File was submitted"
       render 'index'
    else
      render 'new'
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
      @asset = Asset.find(params[:id])
    end
    
    def asset_params
      return params.require(:asset).permit(:uploaded_file)
      #require() marks what params are required
      #permit() limits which parameters can be passed in
    end
    
    def correct_user?
      if (asset.user_id != current_user)
        flash[:warning] = "You have do not have permission to interact with this asset"
        redirect_to root_url
      end
    end
end
