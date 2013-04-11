require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  has_secure_password

  has_many :posts
  has_many :post_votes
  has_many :comments
  has_many :comment_votes

  validates_confirmation_of :password, :message => "Passwords don't match"
end
