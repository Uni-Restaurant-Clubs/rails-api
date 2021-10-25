class CreatorReviewOffer < ApplicationRecord
  belongs_to :restaurant
  belongs_to :content_creator


  validates_presence_of [:creator_id, :restaurant_id, :option_one, :option_two,
                         :option_three]
  validates_uniqueness_of :token, allow_nil: true

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

end
