class Review < ApplicationRecord
  belongs_to :restaurant
  belongs_to :university, optional: true
  belongs_to :writer, class_name: 'ContentCreator', foreign_key: 'writer_id'
  belongs_to :photographer, class_name: 'ContentCreator', foreign_key: 'photographer_id'
  has_many :images

  validates_presence_of :restaurant_id, :writer_id, :photographer_id
  validates :quality_ranking, numericality: { only_integer: true,
                    greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  accepts_nested_attributes_for :images, :allow_destroy => true

  enum status: { "not public" => 0, "open to public" => 1 }

  default_scope { where(status: 1) }
  scope :newest_first, lambda { order("created_at DESC") }
  scope :quality_first, -> { order("quality_ranking DESC") }

  def limit_words
    #full_article.split("<p>").first.split
  end

  def featured_photo
    self.images.featured.first
  end

  def self.create_from_restaurant(restaurant)
    if self.unscoped.where(restaurant_id: restaurant.id).any?
      response = "A review has already been created for this restaurant"
      error = true
    else
      review_data = {
        restaurant_id: restaurant.id,
        photographer_id: restaurant.photographer_id,
        writer_id: restaurant.writer_id,
        status: "not public",
        reviewed_at: restaurant.scheduled_review_date_and_time
      }
      review = self.new(review_data)

      if review.save
        response = "Review created!"
        error = false
      else
        Airbrake.notify("Could not create a review from the restaurant page", {
          errors: review.errors.full_messages,
          restaurant_id: restaurant.id,
          restaurant_name: restaurant.name
        })
        response = review.errors.full_messages
        error = true
      end
    end
    return response, error, review
  end
end
