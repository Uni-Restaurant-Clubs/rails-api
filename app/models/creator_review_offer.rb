class CreatorReviewOffer < ApplicationRecord
  belongs_to :restaurant
  belongs_to :content_creator


  validates_presence_of [:content_creator_id, :restaurant_id, :option_one, :option_two,
                         :option_three]
  validates_uniqueness_of :token, allow_nil: true

  scope :for_writers, -> { where(as_writer: true) }
  scope :for_photographers, -> { where(as_photographer: true) }
  scope :responded_to, -> { where.not(responded_at: nil) }
  scope :oldest_first, -> { order('created_at ASC') }
  scope :option_one_selected, -> { where(option_one_response: true)  }
  scope :option_two_selected, -> { where(option_two_response: true)  }
  scope :option_three_selected, -> { where(option_three_response: true)  }

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

  def selected_a_time_offer?
    option_one_response || option_two_response || option_three_response
  end

  def self.create_and_send_for_role(rest, role, creator_id, everyone=false)
    data = {
      restaurant_id: rest.id,
      option_one: rest.option_1,
      option_two: rest.option_2,
      option_three: rest.option_3,
      token: self.create_new_token,
      as_writer: (role == "writer"),
      as_photographer: (role == "photographer"),
      content_creator_id: creator_id
    }
    begin
      offer = self.create!(data)
      CreatorMailer.with(offer: offer, everyone: everyone)
                   .review_offer_email.deliver_now
      return offer
    rescue Exception => e
      creator_email = ContentCreator.find_by(id: creator_id)&.email
      Airbrake.notify("Issue while creating Creator review offer", {
        error: e,
        offer_errors: offer&.errors&.full_messages,
        creator_id: creator_id,
        creator_email: creator_email,
        restaurant_id: rest.id,
        restaurant_name: rest.name
      })
      return nil
    end
  end

  def self.create_and_send_email_for_creator(restaurant, creator, everyone=false)
    roles = []
    roles << "writer" if creator.is_writer
    roles << "photographer" if creator.is_photographer
    rest = restaurant
    roles.each do |role|
      self.create_and_send_for_role(rest, role, creator.id, everyone)
    end
  end

  def self.create_and_send_email(restaurant, role)
    rest = restaurant
    creator_id = role == "writer" ? rest.writer_id : rest.photographer_id
    self.create_and_send_for_role(rest, role, creator_id)
  end

  def selected_option_and_no_option_reason?(data)
    return (data[:option_one_response] == "1" ||
      data[:option_two_response] == "1" ||
      data[:option_three_response] == "1") &&
      (data[:not_available_for_any_options] == "1" ||
      data[:does_not_want_to_review_this_restaurant] == "1")
  end

  def no_reason_given?(data)
    return data[:does_not_want_to_review_this_restaurant] == "1" &&
      data[:does_not_want_to_review_reason].blank?
  end

  def no_option_selected?(data)
    return data[:option_one_response] != "1" &&
      data[:option_two_response] != "1" &&
      data[:option_three_response] != "1" &&
      data[:not_available_for_any_options] != "1" &&
      data[:does_not_want_to_review_this_restaurant] != "1"
  end

  def validate_response_data(data)
    # TODO add one response per creator per category
    error = false
    # verify it has not been responded to already
    if self.responded_at
      error = "This offer has already been responded too"
    elsif self.no_option_selected?(data)
      # an option must be selected
      error = "Please select an option: one or more date/time option(s), if you're not available or if you do not want to review this restaurant"
    elsif self.selected_option_and_no_option_reason?(data)
      error = "Hmm...looks like you selected a datetime option and selected a can't make it option. Please select one or the other"
    elsif self.no_reason_given?(data)
      # a reason must be given if they select do not want to review
      error = "Please give a reason as to why you do not want to review this restaurant. This will help us find better restaurants for you in the future!"
    end
    error
  end

  def add_response(data)
    self.assign_attributes(data)
    error = self.validate_response_data(data)
    if !error
      begin
        self.responded_at = Time.now
        self.save!
      rescue Exception => e
        Airbrake.notify("Creator review offer could not be responded to", {
          error: e,
          errors: self.errors.full_messages,
          params: data,
          offer_id: self.id,
          restaurant_name: self.restaurant&.name
        })
        error = "Oops! something went wrong. We have been notified and will fix the issue soon!"
      end
    end
    error
  end

  def self.create_offers_and_send_emails_to_rest_of_creators(offer, reason)
    restaurant = offer.restaurant
    restaurant.update!(offer_sent_to_everyone: true)
    creator_ids = self.where(restaurant_id: restaurant.id)
                      .pluck(:content_creator_id)
    lc = LocationCode.find_by(code: "BR")
    creators = ContentCreator.where(location_code_id: lc&.id,
                                    status: "active")
    creators.each do |creator|
      unless creator_ids.include?(creator.id)
        self.create_and_send_email_for_creator(restaurant, creator, true)
      end
    end
    AdminMailer.with(offer: offer, reason: reason)
               .sent_offers_to_all_creators_email.deliver_now
  end

  def self.create_offers_and_send_emails_to_creators(restaurant)
    response = "Offer emails sent successfully!"
    r = restaurant
    error = true
    if r.scheduled_review_date_and_time
      response = "Alert!! Looks like there is already a scheduled review date and time. If you really want to send out new offer emails, the review scheduled time must be removed first. Double check first if you really want to do that!"
    elsif !r.option_1 || !r.option_2 || !r.option_3
      response = "All datetime options must be filled first"
    elsif r.option_1 < TimeHelpers.now ||
          r.option_2 < TimeHelpers.now ||
          r.option_3 < TimeHelpers.now
      response = "The datetime options must be in the future"
    elsif !r.writer_id || !r.photographer_id
      response = "A writer and a photographer must first be selected"
    elsif self.where(restaurant_id: restaurant.id).any?
      response = "Offer emails have already been sent for this restaurant"
    elsif restaurant.initial_offer_sent_to_creators
      response = "It seems that the initial offers have already been sent to the creators. " +
                "Contact an admin if this seems to be an error"
    else
      writer = self.create_and_send_email(restaurant, "writer")
      photographer = self.create_and_send_email(restaurant, "photographer")
      if writer && photographer
        restaurant.update!(initial_offer_sent_to_creators: true)
        error = false
      else
        response = "Oops there was an issue creating the review offers and the team has been notified."
      end
    end
    return response, error
  end
end
