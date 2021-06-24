class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  def self.create_new_confirmation_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(confirmation_token: token)
    end
  end

end
