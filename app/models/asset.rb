class Asset < ApplicationRecord
    belongs_to :user
    
    has_attached_file :asset,
        :url => "/assets/get/:id",
        :path => ":Rails_root/assets/:id/:basename.:extension"
    validates_attachment_presence :asset
    do_not_validate_attachment_file_type :asset
    validates_with AttachmentSizeValidator, attributes: :asset, less_than: 5.megabytes
end
