class Asset < ApplicationRecord
    #attr_accessible :user_id, :uploaded_file
    belongs_to :user
    
    has_attached_file :asset
    validates_attachment_presence :asset
    do_not_validate_attachment_file_type :asset
    validates_with AttachmentSizeValidator, attributes: :asset, less_than: 5.megabytes
end
