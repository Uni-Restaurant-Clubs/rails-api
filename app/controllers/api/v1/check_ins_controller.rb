class Api::V1::CheckInsController < Api::V1::ApiApplicationController
  before_action :authenticate_api_user!, only: [:create]
  before_action :check_subscription!, only: [:create]

  # TODO don't let them double check in for same restaurant within
  # short amount of time
  # add index controller to get check ins just made for that restaurant
  def create
    data = check_in_params
    data[:user_id] = @current_user.id
    feature_period = FeaturePeriod.find_by(id: data[:feature_period_id])
    restaurant = Restaurant.find_by(id: feature_period&.restaurant_id)

    error = false

    if !feature_period
      error = "feature period not found"
    elsif !restaurant
      error = "restaurant not found"
    elsif !data[:latitude] || !data[:longitude]
      error = "no lat or lng"
    end

    data[:restaurant_id] = restaurant.id
    data[:user_is_at_restaurant] = Location.close_enough(restaurant.address, data)

    check_in = CheckIn.new(data)
    if check_in.save
      render json: check_in, status: 200, serializer: CheckInSerializer
    else
      Airbrake.notify("Check in could not be created", {
        errors: check_in.errors.full_messages,
        restaurant_id: restaurant.id,
        restaurant_name: restaurant.name,
        feature_period_id: feature_period.id,
        current_user_email: @current_user&.email
      })

      json = { error: true, message: "" }.to_json
      render json: json, status: 400
    end
  end

  private

    def check_in_params
        params.permit(:feature_period_id, :latitude, :longitude)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
