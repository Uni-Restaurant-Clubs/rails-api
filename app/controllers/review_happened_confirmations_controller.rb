class ReviewHappenedConfirmationsController < ApplicationController

  def edit
    @confirmation = ReviewHappenedConfirmation.find_by(token: params[:id])
    @creator = @confirmation.content_creator
    @restaurant = @confirmation.restaurant
    @confirm_true_url = respond_api_v1_review_happened_confirmation_url(
      @confirmation.token, response: true)
    @confirm_false_url = respond_api_v1_review_happened_confirmation_url(
      @confirmation.token, response: false)
  end
end
