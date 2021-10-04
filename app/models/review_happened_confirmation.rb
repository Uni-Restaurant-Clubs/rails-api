class ReviewHappenedConfirmation < ApplicationRecord

  belongs_to :restaurant
  belongs_to :content_creator

  validates_presence_of [:token, :content_creator_id, :restaurant_id]
  validates_uniqueness_of :token, :allow_blank => true

  def self.create_new_token
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token: token)
    end
  end

  def self.create_for_creator(restaurant, creator)
    puts "creator for creator"
    confirmation_data = {
      content_creator_id: creator.id,
      restaurant_id: restaurant.id,
      token: self.create_new_token,
    }
    confirmation = self.new(confirmation_data)
    begin
      confirmation.save!
    rescue Exception => e
      Airbrake.notify("Review Happened Confirmation couldn't be created", {
        error: e,
        errors: confirmation.errors.full_messages,
        confirmation_data: confirmation_data
      })
      return nil
    end
    return confirmation
  end

  def deliver_confirmation_email
    puts "in deliver confirmation_emails"
    begin
      return CreatorMailer.with(confirmation: self).confirm_review_happened.deliver_now
    rescue Exception => e
      Airbrake.notify("couldn't send Review Happened Confirmation email", {
        error: e,
        confirmation_id: self.id,
        restaurant_id: self.restaurant.id,
        restaurant_name: self.restaurant.name
      })
      return nil
    end
  end
  def self.send_confirmation_emails(restaurant)
    puts "in send_confirmation_emails"
    photographer = restaurant.photographer
    writer = restaurant.writer
    confirmation = self.create_for_creator(restaurant, photographer)
    confirmation.deliver_confirmation_email if confirmation

    unless writer.id == photographer.id
      confirmation = self.create_for_creator(restaurant, writer)
      confirmation.deliver_confirmation_email if confirmation
    end
    return true
  end
end
