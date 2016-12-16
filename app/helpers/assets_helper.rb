module AssetsHelper
    def format_filesize
        
    end
    
    def calculate_storage(user_id)
      storage = 0
      @assets = User.find(user_id).assets.all
      @assets.each do |asset|
        storage += asset.asset.size
      end
      return storage
    end
end
