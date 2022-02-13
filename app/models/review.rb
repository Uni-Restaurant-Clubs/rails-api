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

  def send_review_is_up_email(admin_user_id)

    if review_is_up_email_sent_at
      response = "review is up email already sent"
      error = true
    elsif self.restaurant&.primary_email.blank?
      response = "Restaurant does not have an email address. You need to add one first."
      error = true
    elsif self.images.where(featured: true).empty?
      response = "Review has to have a featured photo"
      error = true
    else
      self.review_is_up_email_sent_at = TimeHelpers.now
      self.review_is_up_email_sent_by_admin_user_id = admin_user_id
      if self.save
        begin
          RestaurantMailer.with(review: self)
                 .send_review_is_up_email.deliver_now
          response = "Review is up email sent!"
          error = false
        rescue Exception => e
          Airbrake.notify("Review is up email couldn't be sent", {
            error: e,
            review_id: self.id,
            restaurant_id: self.restaurant.id,
            restaurant_name: self.restaurant.name
          })
          response = "Review is up email couldn't be sent. Tech team is looking into the issue."
          error = false
        end
      else
        Airbrake.notify("Could not update review when sending review is up email", {
          errors: self.errors.full_messages,
            review_id: self.id,
            restaurant_id: self.restaurant.id,
            restaurant_name: self.restaurant.name
        })
        response = "Could not update restaurant when sending outreach email. Tech team is looking into it."
        error = true
      end
    end
    return response, error

  end

  def upload_multiple_images(images)
    error = false
    response = "Images uploaded!"
    images.each do |image|
      image_data = {
        photo: image,
        image_type: "review",
        review_id: self.id
      }
      image = Image.new(image_data)
      if !image.save
        error = true
        response = image.errors.full_messages
        Airbrake.notify("A review image could not be uploaded", {
          errors: image.errors.full_messages,
          review_id: self.id,
          restaurant_id: self.restaurant.id,
          restaurant_name: self.restaurant.name
        })
      end
    end
    return response, error
  end

  def review_params
    [
      :restaurant_id, :university_id, :writer_id, :photographer_id,
      :reviewed_at, :full_article, :medium_article, :small_article,
      :article_title, :status, :quality_ranking, images: [],
      images_attributes: [
        :id, :title, :photo, :featured, :image_type
      ]
    ]
  end

  def update_from_active_admin(params, admin_user)
    data = params.permit(review_params).to_h.deep_symbolize_keys
    if data[:images] && data[:images].any?
      response, error = upload_multiple_images(data[:images])
      data.delete(:images)
      return response, error if error
    end

    error = false
    response = "review updated!"
    if !self.update(data)
      error = true
      response = self.errors.full_messages
      Airbrake.notify("A review could not be updated in active admin", {
        errors: self.errors.full_messages,
        review_id: self.id,
        restaurant_id: self.restaurant.id,
        restaurant_name: self.restaurant.name
      })
    end
    return response, error
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
