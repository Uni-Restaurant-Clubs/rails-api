class ReviewHappenedConfirmation < ApplicationRecord

  belongs_to :restaurant
  belongs_to :content_creator

  validates_presence_of [:token, :content_creator_id, :restaurant_id]
  validates_uniqueness_of :token, :allow_blank => true

  def update_response_and_handle_next_steps(response)
    restaurant = self.restaurant

    # update confirmation
    self.response = response
    self.responded_at = Time.now
    begin
      self.save!
      if response == "true"

        writer = restaurant.writer
        photogrpher = restaurant.photographer

        unless restaurant.just_reviewed_emails_sent
          CreatorMailer.with(restaurant: restaurant, creator: writer)
            .just_reviewed_email.deliver_now
          unless writer.id == photographer.id
            CreatorMailer.with(restaurant: restaurant, creator: photographer)
              .just_reviewed_email.deliver_now
          end

          RestaurantMailer.with(restaurant: restaurant)
            .just_reviewed_email.deliver_now

          restaurant.just_reviewed_emails_sent = true
          restaurant.status = "reviewed"
          restaurant.save!
        end

        AdminMailer.with(confirmation: self)
          .just_reviewed_email_true.deliver_now

      elsif response == "false"
        AdminMailer.with(confirmation: self)
          .just_reviewed_email_false.deliver_now
        Airbrake.notify("Someone said a review did not happen!", {
          restaurant_id: restaurant.id,
          restaurant_name: restaurant.name,
          confirmation_id: confirmation.id
        })
      end

    rescue Exception => e
      error = "confirmation update validation errors"
      Airbrake.notify("Cannot update ReviewHappenedConfirmation", {
        e: e,
        confirmation_errors: self.errors.full_messages,
        restaurant_errors: restaurant.errors.full_messages,
        response: response,
        confirmation_id: self.id,
        restaurant_id: restaurant.id
      })
    end
  end

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
