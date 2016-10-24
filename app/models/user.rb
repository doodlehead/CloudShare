class User < ApplicationRecord
    #Force all emails to be lowercase
    before_save { self.email = email.downcase }
    
    #Validate name and email
    validates :name, presence: true, length: { maximum: 30 }
    #Regex that identifies a valid email string
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    
    #Adds password functinality(BCrypt gem)
    has_secure_password
    validates :password, length: { minimum: 6}, presence: true
    
    #Password digest method
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
