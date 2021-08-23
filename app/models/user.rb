class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :sessions, dependent: :destroy
  has_many :identities, dependent: :destroy

  validates :email, email: true
  validates_uniqueness_of :passwordless_email_code, :allow_blank => true

  def self.generate_email_code
    numbers = []
    6.times do |i|
      numbers << rand(1...10).round
    end
    numbers.join("")
  end

  def self.create_passwordless_email_code
    loop do
      code = self.generate_email_code
      break code unless self.exists?(passwordless_email_code: code)
    end
  end

  def self.create_new_token(token_name="confirmation_token")
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token_name => token)
    end
  end

  def self.create_from_identity_info(info)
    user_data = {
      email: info[:email],
      first_name: info[:first_name],
      last_name: info[:last_name],
      locale: info[:locale],
      confirmed_at: Time.now
    }
    user = self.new(user_data)
    if user.save(validate: false)
      return user
    else
      Airbrake.notify("user couldn't be created from identity info",
                      { info: info,
                        user_errors: user.errors.full_messages })
      return false
    end
  end

end
