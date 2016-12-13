class Asset < ApplicationRecord
    #attr_accessible :user_id, :uploaded_file
    belongs_to :user
    
    #has_attached_file :uploaded_file
    #validates_attachment_presence :uploaded_file
    #validates_attachment :asset, size: { in: 0..10.megabytes }
end
