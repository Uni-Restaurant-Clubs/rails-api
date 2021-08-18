class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :sessions
  has_many :identities

  def self.create_new_token(token_name="confirmation_token")
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token_name => token)
    end
  end

end
