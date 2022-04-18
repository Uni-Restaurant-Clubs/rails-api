class Api::V1::ReviewsController < Api::V1::ApiApplicationController

  def create_scheduling_info
    data = scheduling_info_params
    code = Recaptcha.get_code(data["recaptcha_token"])
    data.delete("recaptcha_token")
    error = false
    airbrake_error = nil
    status = 200
    restaurant = Restaurant.find_by(scheduling_token: data["token"])
    if !code["success"]
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha did not work for contact form"

    elsif code["score"] < 0.5
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha code less than 0.5 for contact form"

    elsif !data[:option_one] || !data[:option_two] || !data[:option_three]
      error = ["Three date time options are required"]
      airbrake_issue = "Info for required fields missing"

    elsif !restaurant
      error = ["restaurant not found"]
      airbrake_issue = "restaurant not found for schedule form submit"
    elsif restaurant.submitted_scheduling_form_at
      error = ["restaurant already submitted"]
      airbrake_issue = "restaurant already submitted scheduling form"
    end

    if error
      status = 400
      Airbrake.notify(airbrake_error, {
        recaptcha: code,
        data: data,
      })
      json = { error: true, message: error }.to_json
      render json: json, status: status
    else
      restaurant.submitted_scheduling_form_at = Time.now
      restaurant.scheduling_token = nil
      restaurant.status = "accepted"
      restaurant.option_1 = TimeHelpers.keep_time_but_change_timezone(data["option_one"])
      restaurant.option_2 = TimeHelpers.keep_time_but_change_timezone(data["option_two"])
      restaurant.option_3 = TimeHelpers.keep_time_but_change_timezone(data["option_three"])
      restaurant.scheduling_phone_number = data["scheduling_phone_number"]
      restaurant.scheduling_notes = data["scheduling_notes"]
      if restaurant.save
        # send email to team
        AdminMailer.with(restaurant: restaurant).restaurant_submitted_scheduling_info.deliver_later
        RestaurantMailer.with(restaurant: restaurant).restaurant_submitted_scheduling_info.deliver_later
        # send email to restaurant
        promotion_token = Restaurant.create_new_token("promotion_form_token")
        json = { error: false,
                 promotionToken: promotion_token,
                 message: "Scheduling info submitted! We will get back to you soon. Thank you!" }.to_json
        render json: json, status: 200
      else
        status = 400
        Airbrake.notify("restaurant could not be updated on scheduling form submit" , {
          data: data,
          restaurant_name: restaurant.name,
          restaurant_id: restaurant.id
        })
        error = "oops there was an issue and we are looking into it"
        json = { error: true, message: error }.to_json
        render json: json, status: status
      end
    end
  end

  def show
    review = Review.find_by(id: params[:id])
    if !review
      json = { error: true, message: "No review for restaurant" }.to_json
      render json: json, status: 404
    else
      render json: review, status: 200, serializer: ReviewSerializer
    end
  end

  def index
    reviews = Review.quality_first.order("RANDOM()")
    if !reviews
      json = { error: true, message: "No reviews found" }.to_json
      render json: json, status: 404
    else
      render json: reviews.order(:quality_ranking), status: 200, each_serializer: ReviewIndexSerializer
    end
  end

  private

    def scheduling_info_params
      params
        .permit(:optionOne, :optionTwo, :optionThree, :recaptchaToken, :token,
                :schedulingPhoneNumber, :schedulingNotes)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
