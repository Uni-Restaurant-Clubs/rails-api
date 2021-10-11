class Api::V1::ReviewsController < Api::V1::ApiApplicationController

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
    reviews = Review.newest_first.all
    if !reviews
      json = { error: true, message: "No reviews found" }.to_json
      render json: json, status: 404
    else
      render json: reviews, status: 200, each_serializer: ReviewIndexSerializer
    end
  end

end
