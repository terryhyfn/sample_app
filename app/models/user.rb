class User < ActiveRecord::Base
  attr_accessible( :name, :email )
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validate( :name, :presence => true, 
                    :length => { :maximum => 50 } )
  validate( :email, :presence => true, 
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } )
end
