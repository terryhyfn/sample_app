require 'digest'

class User < ActiveRecord::Base
  # create virtual attribute
  attr_accessor(:password, :password_confirmation )  
  attr_accessible( :name, :email, :password, :password_confirmation )
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validate( :name, :presence => true, 
                    :length => { :maximum => 50 } )
  validate( :email, :presence => true, 
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } )
  validate( :password, :presence => true,
                        :confirmation => true,
                        :length => { :within => 6..40 } )
                        
  before_save :encrypted_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt( submitted_password )
  end
  
  def self.authenticate(email, submitted_password )
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?( submitted_password )
  end
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt ) ? user : nil
  end  
  
  private
    def encrypted_password
      # save the salt and encrypted_password to database
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end                             
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end  
end
