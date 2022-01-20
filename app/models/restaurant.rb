class Restaurant < ApplicationRecord

  has_one :address, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :feature_periods, dependent: :destroy
  has_many :check_ins, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :creator_review_offers, dependent: :destroy
  has_many :restaurant_category_restaurants, dependent: :destroy
  has_many :review_happened_confirmation, dependent: :destroy
  has_many :restaurant_categories, through: :restaurant_category_restaurants
  has_many :log_events, dependent: :destroy
  belongs_to :writer, class_name: 'ContentCreator', foreign_key: 'writer_id', optional: true
  belongs_to :photographer, class_name: 'ContentCreator', foreign_key: 'photographer_id', optional: true

  before_save :check_if_review_scheduled
  before_save :notify_admins_and_update_last_changed_field_if_related_to_reviewing

  validates_presence_of [:name, :status]
  validates_uniqueness_of :yelp_id, allow_nil: true
  validates_uniqueness_of :scheduling_token, :allow_blank => true

  enum status: { "not contacted" => 0,
                 "contacted needs follow up" => 1,
                 declined: 2,
                 accepted: 3,
                 "review scheduled" => 4,
                 reviewed: 5,
                 archived: 6,
                 "review did not happen": 7,
                 "confirming review happened": 8 }
  enum contacted_by: { manar: 0, sandra: 1, by_other: 2 }
  enum preferred_contact_method: {
    by_email: 0, by_restaurant_phone: 1, by_cellphone: 2, by_instagram: 3,
    by_facebook_messenger: 4, by_sms: 5
  }
  enum restaurant_replied_through: { email: 0, phone: 1, instagram: 2,
                             facebook_messenger: 3  }
  enum operational_status: { unknown: 0, "temporarily closed" => 1,
                             "permanently closed" => 2,
                             "currently active" => 3 }
  enum urc_rating: { "not rated" => 0, "horrible stay away" => 1,
                     "not very nice" => 2, "ok nothing special" => 3,
                     "cool place" => 4, "amazing place" => 5 }
  enum follow_up_reason: { "need to contact marketing team" => 0,
                           "no answer" => 1, "phone disconnected" => 2,
                           "said to phone back" => 3, other: 4,
                           "Manager Not Available" => 5,
                           "Phone Number Busy" => 6}

  accepts_nested_attributes_for :address, :allow_destroy => true

  scope :brooklyn, lambda { joins(:address).where(address: { city: "Brooklyn" }) }
  scope :franchise, lambda { where(is_franchise: true) }
  scope :not_franchise, lambda { where(is_franchise: false) }
  scope :has_photos, -> { where(photographer_handed_in_photos: true) }
  scope :has_article, -> { where(writer_handed_in_article: true) }
  scope :doesnt_have_photos, -> { where(photographer_handed_in_photos: false) }
  scope :doesnt_have_article, -> { where(writer_handed_in_article: false) }
  scope :active_review_dates, -> do
    where("last_time_a_review_related_date_was_updated > ?",  (TimeHelpers.now - 2.weeks))
  end
  scope :scheduled_in_past, -> do
    where("scheduled_review_date_and_time < ?",  TimeHelpers.now)
  end

  scope :not_reviewed_or_scheduled, -> do
    where.not(status: ["review scheduled",
                       "reviewed",
                       "review did not happen",
                       "confirming review happened"])
  end

  scope :has_three_options, -> do
    where.not(option_1: nil).where.not(option_2: nil).where.not(option_3: nil)
  end
  scope :three_options_nil, -> do
    where(option_1: nil, option_2: nil, option_3: nil)
  end
  scope :has_date_options_and_not_reviewed_or_scheduled, -> do
    self.has_three_options.not_reviewed_or_scheduled
  end

  scope :reviewed_without_content, -> do
    reviewed.where(photographer_handed_in_photos: false)
    .or(self.reviewed.where(writer_handed_in_article: false))
  end

  scope :reviewed_with_content, -> do
    reviewed.where(photographer_handed_in_photos: true,
                   writer_handed_in_article: true)
  end

  scope :scheduled_today, -> do
    where('scheduled_review_date_and_time BETWEEN ? AND ?',
          TimeHelpers.now.beginning_of_day, TimeHelpers.now.end_of_day)
  end

  scope :scheduled_tomorrow, -> do
    where('scheduled_review_date_and_time BETWEEN ? AND ?',
          (TimeHelpers.now + 1.day).beginning_of_day,
          (TimeHelpers.now + 1.day).end_of_day)
  end
  scope :scheduled_in_two_days, -> do
    where('scheduled_review_date_and_time BETWEEN ? AND ?',
          (TimeHelpers.now + 2.day).beginning_of_day,
          (TimeHelpers.now + 2.day).end_of_day)
  end
  scope :not_scheduled_today, -> do
    where.not('scheduled_review_date_and_time BETWEEN ? AND ?',
          TimeHelpers.now.beginning_of_day, TimeHelpers.now.end_of_day)
  end

  scope :not_scheduled_tomorrow, -> do
    where.not('scheduled_review_date_and_time BETWEEN ? AND ?',
          (TimeHelpers.now + 1.day).beginning_of_day,
          (TimeHelpers.now + 1.day).end_of_day)
  end

  scope :not_scheduled_in_next_three_days, -> do
    where.not('scheduled_review_date_and_time BETWEEN ? AND ?',
          (TimeHelpers.now + 2.day).beginning_of_day,
          (TimeHelpers.now + 2.day).end_of_day)
  end

  scope :scheduled_but_not_for_next_three_days, -> do
    self.not_scheduled_today.not_scheduled_tomorrow.not_scheduled_in_next_three_days
        .review_scheduled
  end

  def self.inactive_review_dates
    less_than_two_weeks_ids = self.where("last_time_a_review_related_date_was_updated < ?",
                                     (TimeHelpers.now - 2.weeks)).pluck(:id)
    nil_records_ids = self.where(last_time_a_review_related_date_was_updated: nil)
                      .pluck(:id)
    return self.where(id: less_than_two_weeks_ids.concat(nil_records_ids))
  end

  def send_non_selected_emails_to_all_non_selected_responded_to_offers
    self.creator_review_offers.responded_to.each do |offer|
      creator = offer.content_creator
      # if they are not the selected creators and if they selected
      # a time option then notify them that they were not selected
      if creator.id != writer_id && creator.id != photographer_id &&
          (offer[:option_one_response] ||
           offer[:option_two_response] ||
           offer[:option_three_response])
        begin
          CreatorMailer.with(offer: offer).non_selected_email.deliver_later
        rescue Exception => e
          Airbrake.notify("A non selected email could not have been sent", {
            error: e,
            offer_id: offer.id,
            restaurant_id: self.id,
            restaurant_name: self.name
          })
        end
      end
    end
  end

  def reset_confirmation_information_so_can_resend_initial_offers
    response = "Restaurant UNSCHEDULED correctly"
    error = false
    if self.status != "review scheduled"
      error = true
      response = "status is not currently 'review scheduled' so cannot unschedule. You must change the status to 'review scheduled' if you want to unschedule the review but first DOUBLE CHECK that you really want to do that"
    end
    if !error
      begin
        self.initial_offer_sent_to_creators = false
        self.scheduled_review_date_and_time = nil
        self.offer_sent_to_everyone = false
        self.status = "accepted"
        self.save!
        self.creator_review_offers.destroy_all
      rescue Exception => e
        error = true
        response = "Oops there was an issue unscheduling the restaurant and the tech team has been notified"
        Airbrake.notify("A restaurant could not be UNSCHEDULED", {
          error: e,
          restaurant_errors: self.errors.full_messages,
          restaurant_id: self.id,
          restaurant_name: self.name
        })
      end
    end
    return response, error
  end

  def self.create_new_token(token_name="scheduling_token")
    loop do
      token = SecureRandom.hex(15)
      break token unless self.exists?(token_name => token)
    end
  end

  def create_scheduling_form_url
    self.scheduling_token = Restaurant.create_new_token
    self.scheduling_token_created_at = TimeHelpers.now
    url_base = ENV["FRONTEND_WEB_URL"]
    path = "/reviews/scheduling_info_form"
    query = "/#{self.scheduling_token}"
    self.scheduling_form_url = url_base + path + query
    if self.save
      response = "Scheduling URL Created!"
      error = false
    else
      Airbrake.notify("Could not create a scheduling url", {
        errors: self.errors.full_messages,
        restaurant_id: self.id,
        restaurant_name: self.name
      })
      response = self.errors.full_messages
      error = true
    end
    return response, error
  end

  def handle_after_offer_response_matching(matching_info)
    writer_offer = matching_info[:writer_offer]
    photographer_offer = matching_info[:photographer_offer]
    option = matching_info[:option]
    self.writer_id = writer_offer.content_creator_id
    self.photographer_id = photographer_offer.content_creator_id
    self.scheduled_review_date_and_time = writer_offer[option]
    self.status = "review scheduled"
    rest_id = self.id
    begin
      self.save!
      CreatorReviewOffer::HandlePostMatchNonSelectedResponsesWorker.perform_async(
        rest_id)

      # send out emails
      # send email to writer
      # send email to photographer
      CreatorMailer.with(info: matching_info)
               .send_review_time_scheduled_email.deliver_later
      # send email to restaurant
      RestaurantMailer.with(info: matching_info)
               .send_review_time_scheduled_email.deliver_later
      RestaurantMailer.with(info: matching_info)
               .no_charge_confirmation_email.deliver_later
      # send email to admin
      AdminMailer.with(info: matching_info)
               .send_review_time_scheduled_email.deliver_later
      # create calendar invites
      result = GoogleCalendar.create_scheduled_time_confirmed_for_restaurant(self)
      if result && result.id && result.html_link
        self.restaurant_event_id = result.id
        self.restaurant_event_url = result.html_link
      end
      result = GoogleCalendar.create_scheduled_time_confirmed_for_creators(self)
      if result && result.id && result.html_link
        self.creators_event_id = result.id
        self.creators_event_url = result.html_link
      end
      self.save!
    rescue Exception => e
      Airbrake.notify("Could not update restaurant scheduled time after creator matching", {
        error: e,
        errors: self.errors.full_messages,
        restaurant_id: self.id,
        restaurant_name: self.name
      })
    end
  end

  def self.send_daily_update_emails(time=nil)
    emails = ["monty@unirestaurantclub.com"]
    emails << "kirsys@unirestaurantclub.com"
    emails << "manar@unirestaurantclub.com"
    emails << "sandra@unirestaurantclub.com"
    data = DailySummaryEmail.get_data
    AdminMailer.with(emails: emails, data: data)
               .send_daily_summary_email.deliver_now
  end

  def update_and_send_confirm_if_reviewed_emails
    if !self.photographer || !self.writer
      Airbrake.notify("Restaurant is missing a creator", {
        action: "sending review happened confirmations",
        restaurant_id: self.id,
        restaurant_name: self.name
      })
      puts "creator missing for #{self.name} with ID #{self.id}"
      return
    end
    if ReviewHappenedConfirmation.send_confirmation_emails(self)
      self.status = "confirming review happened"
      begin
        self.save!
      rescue Exception => e
        Airbrake.notify("Restaurant status couldn't be updated", {
          error: e,
          errors: self.errors.full_messages,
          new_status: "confirming review happened",
          restaurant_id: self.id,
          restaurant_name: self.name
        })
        return
      end
    end
  end

  def self.start_confirming_if_reviews_happened_process
    self.review_scheduled.scheduled_in_past.each do |rest|
      if Time.now > (rest.scheduled_review_date_and_time + 2.hours)
        rest.update_and_send_confirm_if_reviewed_emails
      end
    end
  end

  def add_categories(categories)
    categories&.each do |category_data|
      cat_alias = category_data[:alias]
      title = category_data[:title]
      category = RestaurantCategory.find_or_initialize_by(alias: cat_alias, title: title)
      category.save! if category.new_record?
      rest_cat_rest_data = {
        restaurant_id: self.id,
        restaurant_category_id: category.id
      }
      rest_cat_rest = RestaurantCategoryRestaurant.find_or_initialize_by(rest_cat_rest_data)
      rest_cat_rest.save! if rest_cat_rest.new_record?
    end
  end

  def self.categorize_as_franchise
    names = self.not_franchise.pluck(:name).uniq
    names.each do |name|
      restaurants = self.where(name: name)
      if restaurants.count > 1
        restaurants.update_all(is_franchise: true)
      end
    end
  end

  def organized_changed_review_values
    changed_values = {}
    fields = ["status", "scheduled_review_date_and_time",
              "option_1", "option_2", "option_3"]

    fields.each do |field|
      if self.send("#{field}_changed?")
        changed_fields = self.send("#{field}_change")
        next if field == "status" &&
          (changed_fields[1] != "accepted" &&
          changed_fields[1] != "review scheduled")

        if field == "status"
          # Handle status being changed to accepted or review scheduled
          if changed_fields[1] == "accepted" && self.accepted_at.nil?
            self.accepted_at = TimeHelpers.now
          end
          value_before = changed_fields[0]
          value_after = changed_fields[1]
        else
          value_before = TimeHelpers.to_human(changed_fields[0])
          value_after = TimeHelpers.to_human(changed_fields[1])
        end
        changed_values[field] = [value_before, value_after]
      end
    end
    return changed_values
  end

  private

  def notify_admins_and_update_last_changed_field_if_related_to_reviewing
    changed_values = organized_changed_review_values
    if changed_values.length > 0
      self.last_time_a_review_related_date_was_updated = TimeHelpers.now
      begin
        AdminMailer.with(restaurant: self, changed_values: changed_values)
                   .review_times_have_been_updated_for_restaurant.deliver_later
      rescue Exception => e
        Airbrake.notify("A review info changed email could not be sent", {
          error: e,
          restaurant_id: self.id,
          restaurant_name: self.name,
          changed_values: changed_values
        })
      end
    end
  end

  def check_if_review_scheduled
    if scheduled_review_date_and_time &&
        writer && photographer &&
        status == "accepted"
      self.status = "review scheduled"
    end
  end
end
