class User
  include Ripple::Document
  include ActiveModel::SecurePassword 

  property :username, String, presence: true, index: true
  property :email, String
  property :password_digest, String, presence: true 
  timestamps!

  has_secure_password
end