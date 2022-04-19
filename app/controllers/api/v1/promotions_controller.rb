class Api::V1::PromotionsController < Api::V1::ApiApplicationController

  def is_interested
    error = nil
    status = 200

    token = params[:token]
    restaurant = Restaurant.where(promotion_form_token: token)
    if !restaurant
      error = "restaurant cannot be found"
      status = 400
    else
      restaurant.promotion_form_step_one_completed_at = TimeHelpers.now
      if !restaurant.save
        status = 400
        error = "restaurant could not be updated after interested in being promoted"
        Airbrake.notify(error, {
          restaurant: restaurant.name,
          restaurant_id: restaurant.id,
          errors: restaurant.errors.full_messages
        })
      end
    end
    json = { error: true,
             message: "Oops something went wrong. Please try again soon." }.to_json
    render json: json, status: 400
  end

end
