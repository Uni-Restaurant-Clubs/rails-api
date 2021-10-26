class CreatorReviewOffer < ApplicationRecord
  belongs_to :restaurant
  belongs_to :content_creator


  validates_presence_of [:content_creator_id, :restaurant_id, :option_one, :option_two,
                         :option_three]
  validates_uniqueness_of :token, allow_nil: true

  def roles
    roles = []
    roles << "writer" if as_writer
    roles << "photographer" if as_photographer
    roles << "videographer" if as_videographer
    roles.join(", ")
  end

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

  def self.create_and_send_email(restaurant, role)
    rest = restaurant
    creator_id = role == "writer" ? rest.writer_id : rest.photographer_id
    data = {
      restaurant_id: rest.id,
      content_creator_id: creator_id,
      option_one: rest.option_1,
      option_two: rest.option_2,
      option_three: rest.option_3,
      token: self.create_new_token,
      as_writer: (role == "writer"),
      as_photographer: (role == "photographer")
    }
      offer = self.create!(data)
      CreatorMailer.with(offer: offer).review_offer_email.deliver_now
  end

  def self.create_offers_and_send_emails_to_creators(restaurant)
    response = "Offer emails sent successfully!"
    r = restaurant
    error = true
    if !r.option_1 || !r.option_2 || !r.option_3
      response = "All datetime options must be filled first"
    elsif r.option_1 < Time.now || r.option_2 < Time.now || r.option_3 < Time.now
      response = "The datetime options must be in the future"
    elsif !r.writer_id || !r.photographer_id
      response = "A writer and a photographer must first be selected"
    elsif self.where(restaurant_id: restaurant.id).any?
      response = "Offer emails have already been sent for this restaurant"
    else
      begin
        self.create_and_send_email(restaurant, "writer")
        self.create_and_send_email(restaurant, "photographer")
        error = false
      rescue Exception => e
        Airbrake.notify("Issue while creating Creator review offer", {
          error: e,
          restaurant_id: restaurant.id,
          restaurant_name: restaurant.name
        })
        response = "Oops there was an issue creating the review offers and the team has been notified."
      end
    end
    return response, error
  end
end
