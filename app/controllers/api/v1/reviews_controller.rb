class Api::V1::ReviewsController < Api::V1::ApiApplicationController

  def show
    review = Review.find_by(id: params[:id])
    if !review
      json = { error: true, message: "No review for restaurant" }.to_json
      render json: json, status: 404
    else
      render json: review, status: 200
    end
  end

  def index
    reviews = Review.all
    if !reviews
      json = { error: true, message: "No reviews found" }.to_json
      render json: json, status: 404
    else
      render json: reviews, status: 200
    end
  end

end
