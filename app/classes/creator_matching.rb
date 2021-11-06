class CreatorMatching

  def self.categorize_by_options(writer_responses, photographer_responses)
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
    option_one_writers = option_one_writers
    option_one_photographers = option_one_photographers
    option_two_writers = option_two_writers
    option_two_photographers = option_two_photographers
    option_three_writers = option_three_writers
    option_three_photographers = option_three_photographers

    if option_one_writers.any? && option_one_photographers.any?
      return {
        writer: option_one_writers.first,
        photographer: option_one_photographers.first
      }
    elsif option_two_writers.any? && option_two_photographers.any?
      return {
        writer: option_two_writers.first,
        photographer: option_two_photographers.first
      }
    elsif option_three_writers.any? && option_three_photographers.any?
      return {
        writer: option_three_writers.first,
        photographer: option_three_photographers.first
      }
    else
      nil
    end
  end

  def self.order_by_criteria(responses, offer)
    # add ordering by criteria logic here
    # TODO add point system
    responses
  end

  def self.handle_post_response_matching(offer)

    filter_data = {
      restaurant_id: offer.restaurant_id
    }

    # get all writer responses
    writer_responses = CreatorReviewOffer.where(filter_data)
                                         .for_writers
                                         .responded
                                         .oldest_first

    writer_responses = self.order_by_criteria(writer_ responses, offer)
    # get all photographer responses
    photographer_responses = CreatorReviewOffer.where(filter_data)
                                         .for_photographers
                                         .responded
                                         .oldest_first

    photographer_responses = self.order_by_criteria(photographer_responses, offer)

    return if writer_responses.empty? || photographer_responses.empty?

    match = self.match(writer_responses, photographer_responses)
    writer = match[:writer]
    photographer = match[:photographer]

    #
    # if match, update final scheduled time
    # send confirmation emails to restaurant and creators
    # create and send google events
    #
    # if no match
    # send out to everyone
    # first response gets it

  end

end
