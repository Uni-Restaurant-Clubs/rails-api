class Api::V1::ReviewsController < Api::V1::ApiApplicationController

  def create_scheduling_info
    data = scheduling_info_params
    code = Recaptcha.get_code(data["recaptcha_token"])
    data.delete("recaptcha_token")
    error = false
    airbrake_error = nil
    status = 200
    if !code["success"]
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha did not work for contact form"

    elsif code["score"] < 0.5
      error = "Oops there was an issue and we are working on resolving it."
      airbrake_issue = "Recaptcha code less than 0.5 for contact form"

    elsif !data[:option_one] || !data[:option_two] || !data[:option_three]
      error = ["Three date time options are required"]
      airbrake_issue = "Info for required fields missing"

      #TODO add more validations to make sure restaurant exists and that
      # they haven't replied already
      # validate token
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
      # TODO: update info here
        json = { error: true,
                 message: "Oops something went wrong. Please try again soon." }.to_json
        render json: json, status: 400
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
        .permit(:optionOne, :optionTwo, :optionThree, :recaptchaToken)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
