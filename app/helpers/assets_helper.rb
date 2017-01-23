#Collection of helper methods related to Assets

module AssetsHelper
    def format_filesize
        #to be implemented...
    end
    
    #Calcualtes the total amount of storage a user has taken.
    def calculate_storage(user_id)
      storage = 0
      @assets = User.find(user_id).assets.all
      @assets.each do |asset|
        storage += asset.asset.size
      end
      return storage
    end
    
    #Checks to see if a file is shareable with the user with the id=share_with
    def shareable?(share_with)
      str = @asset.shared_with.to_s
      a = str.split(",")
      #Ensures that the file isn't being shared to ones self
      if share_with == current_user.id
        return false
      end
      #Ensures that the file isn't being shared to someone it has already been shared to.
      0.upto(a.length-1) do |x|
        if a[x].to_i == share_with
          return false
        end
      end
      return true
    end
    
    #Unused and imcomplete method that sorts all the assets owned by user alphabetically
    def sort_alpha
      @assets = @assets.sort_by { |h| h[:name] }
      #redirect_to user_path
    end
    
end
