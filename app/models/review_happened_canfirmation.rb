class ReviewHappenedCanfirmation < ApplicationRecord

  belongs_to :restaurant
  belongs_to :content_creator

  validates_presence_of [:token, :creator_id, :restaurant_id]

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

end
