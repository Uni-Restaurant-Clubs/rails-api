class ReviewHappenedConfirmation < ApplicationRecord

  belongs_to :restaurant
  belongs_to :content_creator

  validates_presence_of [:token, :creator_id, :restaurant_id]
  validates_uniqueness_of :token, :allow_blank => true

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

  def self.create_for_creator(restaurant, creator)
    confirmation_data = {
      content_creator_id: creator.id,
      restaurant_id: restaurant.id,
      token: self.create_new_token,
    }
    confirmation = self.new(confirmation_data)
    begin
      return confirmation.save!(confirmation_data)
    rescue Exception => e
      Airbrake.notify("Review Happened Confirmation couldn't be created", {
        error: e,
        errors: confirmation.errors.full_messages,
        confirmation_data: confirmation_data
      })
      return nil
    end
  end

  def self.send_confirmation_emails(restaurant)
    photographer = restaurant.photographer
    writer = restaurant.writer
    if !photographer || !writer
      Airbrake.notify("Restaurant is missing a creator", {
        action: "sending review happened confirmations",
        restaurant_id: restaurant.id,
        restaurant_name: restaurant.name
      })
      return
    end
    confirmation = self.create_for_creator(restaurant, photographer)
    if confirmation
      CreatorMailor.with(confirmation: confirmation).confirm_review_happened
                                                    .deliver_now
    end
    unless writer.id == photographer.id
      confirmation = self.create_for_creator(restaurant, writer)
      if confirmation
        CreatorMailor.with(confirmation: confirmation).confirm_review_happened
                                                    .deliver_now

      end
    end

  end
end
