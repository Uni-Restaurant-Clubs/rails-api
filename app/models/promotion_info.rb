class PromotionInfo < ApplicationRecord

  belongs_to :restaurant

  validates_presence_of [:restaurant_id]

  enum restaurant_status: {
    sent_promotional_intro_email: 0,
    not_interested: 1,
    interested: 2,
    ready_to_be_featured: 3,
    being_featured: 4,
    previously_featured: 5,
    need_to_send_promo_intro_email: 7,
    need_to_send_review_is_up_email: 8,
    need_to_post_to_instagram: 9
  }

  def self.sent_promotion_intro_email_more_than_seven_days_ago
    self.where(restaurant_status: :sent_promotional_intro_email)
      .where("promotion_intro_email_sent_at < ?",  (TimeHelpers.now - 7.days))
  end

  def self.sent_promotional_intro_email_within_last_seven_days
    self.where(restaurant_status: :sent_promotional_intro_email)
      .where("promotion_intro_email_sent_at > ?",  (TimeHelpers.now - 7.days))
  end

  # create a method that is called from a cron job to send promotion initial
  # emails out to any restaurants where a your review is up email was sent 2
  # days before
  def self.send_initial_promotion_email_out(review)
    restaurant = review.restaurant
    promotion_info = restaurant.promotion_info

    if promotion_info&.promotion_intro_email_sent_at.present? ||
        review.promotion_intro_email_sent
      return false
    else
      begin
        puts "Sending promoting intro email to #{restaurant.name}"
        RestaurantMailer.with(restaurant: restaurant)
                        .send_initial_promotion_email.deliver_now

        if !promotion_info
          promotion_info_data = {
            restaurant_id: restaurant.id,
            promotion_intro_email_sent_at: Time.now,
            restaurant_status: :sent_promotional_intro_email
          }
          promotion_info = PromotionInfo.new(promotion_info_data)
          review.promotion_intro_email_sent = true
          if promotion_info.save && review.save
            return true
          else
            Airbrake.notify("A promotion info or review could not have been created or updated while sending promotion intro email", {
              error: e,
              promotion_info_errors: promotion_info.errors.full_messages,
              review_errors: review.errors.full_messages,
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
    reviews = Review.where.not(review_is_up_email_sent_at: nil)
                    .where(promotion_intro_email_sent: false)
                    .where('review_is_up_email_sent_at < ?', two_days_ago)

    reviews.each do |review|
      self.send_initial_promotion_email_out(review)
    end
  end
end
