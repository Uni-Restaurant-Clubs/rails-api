class CreatorMatching

  # Logic for creator review offer post response matching goes here

  def self.categorize_by_options(writer_responses, photographer_responses)
    ######  CATEGORIZING LOGIC HERE ##################
    {
      option_one: {
        writers: writer_responses.option_one_selected,
        photographers: photographer_responses.option_one_selected
      },
      option_two: {
        writers: writer_responses.option_two_selected,
        photographers: photographer_responses.option_two_selected
      },
      option_three: {
        writers: writer_responses.option_three_selected,
        photographers: photographer_responses.option_three_selected
      },
    }
  end

  def self.match(writer_responses, photographer_responses)
    matched = false
    responses_by_options = self.categorize_by_options(writer_responses,
                                                     photographer_responses)
    # TODO: filter option group by point system
    # if both have a point 1 then go with that (check all option groups before chosing)
    # option one check for point 1 matches else check option 2, 3 etc..
    # if no point 1, do again for point 2
    option_one = responses_by_options[:option_one]
    option_two = responses_by_options[:option_two]
    option_three = responses_by_options[:option_three]
    option_one_writers = option_one[:writers]
    option_one_photographers = option_one[:photographers]
    option_two_writers = option_two[:writers]
    option_two_photographers = option_two[:photographers]
    option_three_writers = option_three[:writers]
    option_three_photographers = option_three[:photographers]

    ######  MATCHING LOGIC HERE ##################
    if option_one_writers.any? && option_one_photographers.any?
      return {
        writer_offer: option_one_writers.first,
        photographer_offer: option_one_photographers.first,
        option: :option_one
      }
    elsif option_two_writers.any? && option_two_photographers.any?
      return {
        writer_offer: option_two_writers.first,
        photographer_offer: option_two_photographers.first,
        option: :option_two
      }
    elsif option_three_writers.any? && option_three_photographers.any?
      return {
        writer_offer: option_three_writers.first,
        photographer_offer: option_three_photographers.first,
        option: :option_three
      }
    else
      nil
    end
  end

  def self.order_by_criteria(responses, offer)
    ######  ORDERING BY CRITERIA LOGIC HERE ##################
    # add ordering by criteria logic here
    # TODO add point system
    responses
  end

  def self.get_writer_and_photographer_matching_info(offer)
    filter_data = {
      restaurant_id: offer.restaurant_id
    }

    # get responded offers
    responses = CreatorReviewOffer.where(filter_data).responded_to
    # get all writer responses
    writer_responses = responses.for_writers.oldest_first
    writer_responses = self.order_by_criteria(writer_responses, offer)

    # get all photographer responses
    photographer_responses = responses.for_photographers.oldest_first
    photographer_responses = self.order_by_criteria(photographer_responses, offer)

    return if writer_responses.empty? || photographer_responses.empty?

    matching_info = self.match(writer_responses, photographer_responses)
    matching_info
  end

  def self.send_offers_to_everyone_if_havent_yet(rest)
    if !rest.offer_sent_to_everyone
      CreatorReviewOffer.create_offers_and_send_emails_to_rest_of_creators(rest)
    end
  end

  def self.handle_post_response_matching(offer)
    rest = offer.restaurant

    if offer[:does_not_want_to_review_this_restaurant] ||
        offer[:not_available_for_any_options]
      # declined so no match
      # send out to everyone if haven't sent out to everyone yet
      self.send_offers_to_everyone_if_havent_yet(rest)

    else
      matching_info = self.get_writer_and_photographer_matching_info(offer)
      if matching_info
        # there is a matching time so send out confirmations
        offer.restaurant.handle_after_offer_response_matching(matching_info)

        # there is no matching time
      elsif rest.creator_review_offers.responded_to.count > 1
        # both initial offers have been responded to
        # send offer to everyone if haven't yet
        self.send_offers_to_everyone_if_havent_yet(rest)
      end
    end
  end

  def self.check_for_no_answers
    # get all restaurants that have had initial offers sent with no matches
    # and offer hasn't been sent out to everyone yet
    restaurants = Restaurant.where(initial_offers_sent_to_creators: true)
                            .where(offer_sent_to_everyone: false)
                            .where(scheduled_review_date_and_time: nil)
    restaurants.each do |restaurant|
      first_offer_time = restaurant.creator_review_offers.first&.created_at
      if (Time.now - 24.hours) > first_offer_time
        # send offer to everyone if it's been more than 24 hours since the offer
        # was sent and there's still no reply
        self.send_offers_to_everyone_if_havent_yet(rest)
      end
    end
  end
end
