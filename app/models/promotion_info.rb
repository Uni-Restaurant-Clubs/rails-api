class PromotionInfo < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of [:restaurant_id]

  enum restaurant_status: {
    sent_promotional_intro_email: 0,
    not_interested: 1,
    interested_and_need_to_talk_details: 2,
    ready_to_be_featured: 3,
    being_featured: 4,
    previously_featured: 5
  }

  # create a method that is called from a cron job to send promotion initial
  # emails out to any restaurants where a your review is up email was sent 2
  # days before
  def self.send_initial_promotion_email_out(restaurant)
    promotion_info = restaurant.promotion_info
    if promotion_info&.promotion_intro_email_sent_at.present?
      return false
    else
      # send email
      # wrap in begin, exception
      begin
        RestaurantMailer.with(restaurant: restaurant)
                        .send_initial_promotion_email.deliver_now

        if !promotion_info
          promotion_info_data = {
            restaurant_id: restaurant.id,
            promotion_intro_email_sent_at: Time.now,
            restaurant_status: :sent_promotional_intro_email
          }
          promotion_info = PromotionalInfo.new(promotion_info_data)
          if promotion_info.save

          else
            Airbrake.notify("A promotion info could not have been created", {
              error: e,
              errors: promotion_info.errors.full_messages,
              restaurant_id: restaurant.id,
              restaurant_name: restaurant.name
            })
          end
        end
      rescue Exception => e
        Airbrake.notify("An initial promotion email could not have been sent", {
          error: e,
          restaurant_id: restaurant.id,
          restaurant_name: restaurant.name
        })
      end
    end
  end

  def self.send_initial_promotion_emails_out
    # find all restaurants where review is up email was sent more than 2 days ago
    # and an initial promotion email has not been sent out yet
    two_days_ago = TimeHelpers.now - 2.days
    restaurant_ids = Review.where.not(review_is_up_email_sent_at: nil)
                          .where('review_is_up_email_sent_at < ?', two_days_ago)
                          .pluck(:restaurant_id)

    promotion_info_restaurant_ids = self.where(restaurant_id: restaurant_ids)
                                    .where.not(promotion_intro_email_sent_at: nil)
                                    .pluck(:restaurant_id)

    left_over_restaurant_ids = restaurant_ids - promotion_info_restaurant_ids
    restaurants = Restaurant.where(id: left_over_restaurant_ids)
    restaurants.each do |restaurant|
      self.send_initial_promotion_email_out(restaurant)
    end
  end
end
