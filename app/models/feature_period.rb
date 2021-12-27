class FeaturePeriod < ApplicationRecord
  has_many :check_ins, dependent: :destroy
  belongs_to :restaurant

  scope :has_started, -> do
    where("start_date < ?", TimeHelpers.now)
  end

  scope :has_not_ended, -> do
    where("end_date > ?", TimeHelpers.now)
  end

  scope :currently_featured, ->{ has_started.has_not_ended }

  enum discount_type: { dollar: 0, percentage: 1, items: 2 }
  enum status: { feature_not_live: 0, feature_live: 1 }

  def self.create_from_restaurant(restaurant)
    if self.unscoped.where(restaurant_id: restaurant.id).any?
      response = "A feature period has already been created for this restaurant"
      error = true
    else
      feature_period_data = {
        restaurant_id: restaurant.id,
        status: "feature_not_live",
      }
      feature_period = self.new(feature_period_data)

      if feature_period.save
        response = "Feature period created!"
        error = false
      else
        Airbrake.notify("Could not create a feature period from the restaurant page", {
          errors: feature_period.errors.full_messages,
          restaurant_id: restaurant.id,
          restaurant_name: restaurant.name
        })
        response = feature_period.errors.full_messages
        error = true
      end
    end
    return response, error, feature_period
  end
end
