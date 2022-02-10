class User < ActiveRecord::Base

  has_many :finstagram_posts
  has_many :comments
  has_many :likes

  validates :email, :username, uniqueness: true
  validates :email, :username, :password, presence: true
  
end