class Api::V1::PromotionsController < Api::V1::ApiApplicationController

  def not_interested
    error = nil
    status = 200

    token = params[:token]
    restaurant = Restaurant.find_by(promotion_form_token: token)
    if !restaurant
      error = "restaurant cannot be found"
      status = 400
      Airbrake.notify("restaurant could not be found during promotion not interested button click", {
        errors: restaurant.errors.full_messages
      })
    elsif restaurant.selected_not_interested_in_promotion_at
      error = "restaurant already said they weren't interested"
      status = 400
    else
      restaurant.selected_not_interested_in_promotion_at = TimeHelpers.now
      if !restaurant.save
        status = 400
        error = "Promotion info could not be created after interested in being promoted"
        Airbrake.notify(error, {
          restaurant: restaurant.name,
          restaurant_id: restaurant.id,
          errors: restaurant.errors.full_messages
        })
      end
    end
    json = { error: error.present?,
             promotionToken: token,
             message: error }.to_json
    render json: json, status: status
  end

  def is_interested
    error = nil
    status = 200

    token = params[:token]
    restaurant = Restaurant.find_by(promotion_form_token: token)
    if !restaurant
      error = "restaurant cannot be found"
      status = 400
    else
      promotion_info = PromotionInfo.find_or_initialize_by(restaurant_id: restaurant.id)
      if promotion_info.form_step_one_completed_at?
        status = 400
        error = "Restaurant already said that they were interested"
      else
        promotion_info.form_step_one_completed_at = TimeHelpers.now
        if promotion_info.save
          #TODO send an email to admin saying that a restaurant is interested
        else
          status = 400
          error = "Promotion info could not be created after interested in being promoted"
          Airbrake.notify(error, {
            restaurant: restaurant.name,
            restaurant_id: restaurant.id,
            errors: promotion_info.errors.full_messages
          })
        end
      end
    end
    json = { error: error.present?,
             promotionToken: token,
             message: error }.to_json
    render json: json, status: status
  end

end
