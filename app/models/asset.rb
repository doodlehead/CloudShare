class Asset < ApplicationRecord
    belongs_to :user
    
    has_attached_file :asset
    validates_attachment size: { in: 0..10.megabytes }
end
