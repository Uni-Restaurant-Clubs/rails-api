class Restaurant < ApplicationRecord

  has_one :address, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :restaurant_category_restaurants, dependent: :destroy
  has_many :review_happened_confirmation, dependent: :destroy
  has_many :restaurant_categories, through: :restaurant_category_restaurants
  belongs_to :writer, class_name: 'ContentCreator', foreign_key: 'writer_id', optional: true
  belongs_to :photographer, class_name: 'ContentCreator', foreign_key: 'photographer_id', optional: true

  before_save :check_if_review_scheduled

  validates_presence_of [:name, :status]
  validates_uniqueness_of :yelp_id, allow_nil: true

  enum status: { "not contacted" => 0,
                 "contacted needs follow up" => 1,
                 declined: 2,
                 accepted: 3,
                 "review scheduled" => 4,
                 reviewed: 5,
                 archived: 6,
                 "review did not happen": 7,
                 "confirming review happened": 8 }
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
  scope :scheduled_in_past, -> do
    where("scheduled_review_date_and_time < ?", DateTime.now)
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
          DateTime.now.beginning_of_day, DateTime.now.end_of_day)
  end

  scope :scheduled_tomorrow, -> do
    where('scheduled_review_date_and_time BETWEEN ? AND ?',
          (DateTime.now + 1.day).beginning_of_day,
          (DateTime.now + 1.day).end_of_day)
  end
  scope :not_scheduled_today, -> do
    where.not('scheduled_review_date_and_time BETWEEN ? AND ?',
          DateTime.now.beginning_of_day, DateTime.now.end_of_day)
  end

  scope :not_scheduled_tomorrow, -> do
    where.not('scheduled_review_date_and_time BETWEEN ? AND ?',
          (DateTime.now + 1.day).beginning_of_day,
          (DateTime.now + 1.day).end_of_day)
  end

  scope :scheduled_but_not_for_today_or_tomorrow, -> do
    self.not_scheduled_today.not_scheduled_tomorrow.review_scheduled
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

  private

  def check_if_review_scheduled
    if scheduled_review_date_and_time &&
        writer && photographer &&
        status == "accepted"
      self.status = "review scheduled"
    end
  end
end
