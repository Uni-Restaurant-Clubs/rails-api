class Restaurant < ApplicationRecord

  has_one :address, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :restaurant_category_restaurants, dependent: :destroy
  has_many :restaurant_categories, through: :restaurant_category_restaurants
  belongs_to :writer, class_name: 'ContentCreator', foreign_key: 'writer_id', optional: true
  belongs_to :photographer, class_name: 'ContentCreator', foreign_key: 'photographer_id', optional: true

  validates_presence_of [:name, :status]
  validates_uniqueness_of :yelp_id, allow_nil: true

  enum status: { "not contacted" => 0, "contacted needs follow up" => 1,
                 declined: 2, accepted: 3, "review scheduled" => 4, reviewed: 5,
                 archived: 6 }
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

  scope :reviewed_without_content, -> do
    reviewed.where(photographer_handed_in_photos: false)
    .or(self.reviewed.where(writer_handed_in_article: false))
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

end
