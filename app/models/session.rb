class Session < ApplicationRecord

  belongs_to :user
  validates_presence_of :token, :user_id
  validates_uniqueness_of :token, allow_nil: true

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

end
