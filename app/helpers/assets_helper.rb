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
    
    #not returning false
    def shareable?(share_with)
      str = @asset.shared_with.to_s
      a = str.split(",")
      #can't share file with one self
      if share_with == current_user.id
        return false
      end
      0.upto(a.length-1) do |x|
        if a[x].to_i == share_with
          return false
        end
      end
      return true
    end
end
