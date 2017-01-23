class User < ApplicationRecord
    #This is an active record association. It forms relationships between models, useful for allowing "rails magic" to automatically make operations between the two simpler.
    #Here, we've made it so one asset belongs to a user.
    #For more info, visit http://guides.rubyonrails.org/association_basics.html
    has_many :assets
    
    #Force all emails to be lowercase
    before_save { self.email = email.downcase }
    
    #Validate name and email
    validates :name, presence: true, length: { maximum: 30 }
    #Regex that identifies a valid email string
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
    
    #Adds hashed and salted password functinality(BCrypt gem)
    has_secure_password
    #Does a bunch of stuff behind the scenes, refer to: http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html
    validates :password, length: { minimum: 6}, presence: true
    
    #Password digest method
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
end
