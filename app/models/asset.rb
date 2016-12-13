class Asset < ApplicationRecord
    #attr_accessible :user_id, :uploaded_file
    belongs_to :user
    
    has_attached_file :asset
    validates_attachment_presence :asset
    do_not_validate_attachment_file_type :asset
    #validates_attachment :asset, size: { in: 0..10.megabytes }
end
