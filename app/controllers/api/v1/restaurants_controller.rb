class Api::V1::RestaurantsController < Api::V1::ApiApplicationController

  def info_for_scheduling_form
    token = params[:id]
    restaurant = Restaurant.find_by(scheduling_token: token)
    error = false

    if !token
      error = "missing token"
    elsif !restaurant
      error = "restaurant not found"
    elsif restaurant.submitted_scheduling_form_at
      error = "Restaurant already submitted scheduling form"
    elsif restaurant.scheduling_token_created_at < (Time.now - 6.months)
      error = "token is too old"
    end

    if error
      Airbrake.notify("Cannot get info for restaurant for scheduling form", {
        error: error,
        token: token,
        restaurant_id: restaurant&.id,
        restaurant_name: restaurant&.name,
      })
      json = { error: true, message: error }.to_json
      render json: json, status: 400
    else
      render json: restaurant, status: 200, serializer: RestaurantSchedulingFormInfoSerializer
    end

  end

end
