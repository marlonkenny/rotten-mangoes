class User < ActiveRecord::Base
  has_many :reviews
  
  has_secure_password

  validates :email, :firstname, :lastname,
    presence: :true

  validates :email, uniqueness: :true

  validates :password,
    length: { in: 6..20 }, on: :create

end
