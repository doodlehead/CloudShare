#This model handles a users files.
class Asset < ApplicationRecord
    
    #This is an active record association. It forms relationships between models, useful for allowing "rails magic" to automatically make operations between the two simpler.
    #Here, we've made it so one asset belongs to a user.
    #For more info, visit http://guides.rubyonrails.org/association_basics.html
    belongs_to :user
    
    #Used in file encryption
    attr_accessor :password 
       
    #The last block of code here is from paperclip, a file handling gem (API)
    #has_attached_file links a file to an asset object
    has_attached_file :asset,
        :url => "/assets/get/:id",
        :path => ":Rails_root/assets/:id/:basename.:extension"
        
    #The following are just some validations that are used upon uploading files, checking to see if it exists, and if it is less than 5 mb in size
    validates_attachment_presence :asset
    do_not_validate_attachment_file_type :asset
    validates_with AttachmentSizeValidator, attributes: :asset, less_than: 5.megabytes
end
