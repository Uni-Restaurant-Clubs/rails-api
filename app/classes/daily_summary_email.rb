class DailySummaryEmail

  def self.get_data
    data = {}

    restaurants = Restaurant.brooklyn
    ########## TODAYS REVIEWS ###################
    reviews = restaurants.review_scheduled.scheduled_today
    data[:todays_reviews] = {
      count: reviews.count,
      reviews: reviews
    }

    ########## TOMORROWS REVIEWS ###################
    reviews = restaurants.review_scheduled.scheduled_tomorrow
    data[:tomorrows_reviews] = {
      count: reviews.count,
      reviews: reviews
    }

    ########## CONFIRMING REVIEWS HAPPENED ###################
    # Needing "review happened" confirmations from creator(s)
    reviews = restaurants.confirming_review_happened
    data[:confirming_review_happened] = {
      count: reviews.count,
      reviews: reviews
    }

    ########## OTHER SCHEDULED ###################
    # Scheduled restaurants (not today or tomorrow)
    reviews = restaurants.brooklyn.scheduled_but_not_for_today_or_tomorrow
    data[:scheduled_but_not_today_or_tomorrow] = {
      count: reviews.count,
      reviews: reviews
    }

    ########## REVIEWED AND NEEDING CONTENT ###################
    reviews = restaurants.brooklyn.reviewed_without_content
    data[:reviewed_but_needing_content] = {
      count: reviews.count,
      reviews: reviews
    }

    ########## ACCEPTED AND NEEDING A CONFIRMED REVIEW TIME ###################
    reviews = restaurants.brooklyn.accepted
    data[:accepted] = {
      count: reviews.count,
      reviews: reviews
    }

    gif = Giphy.get_random("excited")
    image = gif[:data][:images][:downsized_large] rescue nil
    if image
      data[:gif] = {
        url: image[:url],
        height: image[:height],
        width: image[:width],
      }
    end
    return data
  end

end
