class User < ApplicationRecord
    #Force all emails to be lowercase
    before_save { self.email = email.downcase }
    
    #Validate name and email
    validates :name, presence: true
    validates :email, presence: true
    
   # 
    has_secure_password
    validates :password
end
