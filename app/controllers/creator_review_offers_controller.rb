class CreatorReviewOffersController < ApplicationController

  def edit
    @token = params[:id]
    @offer = CreatorReviewOffer.find_by(token: @token)
    if !@offer
      @error = "Offer no longer valid"
    elsif @offer.restaurant&.scheduled_review_date_and_time
      @error = "Offer no longer valid"
    elsif @offer.responded_at
      # verify it has not been responded to already
      @error = "This offer has already been responded to"
    elsif TimeHelpers.now > @offer.created_at + 2.days
      # validate date (can't be more than 2 days old)
      @error = "This offer has expired since it was sent more than 2 days ago."
    end
    flash[:alert] = @error
  end

  def update
    @offer = CreatorReviewOffer.find_by(id: params[:id])
    if !@offer
      error = "This offer is no longer valid."
      @error = true
    elsif @offer.restaurant&.scheduled_review_date_and_time
      error = "This offer is no longer valid. Looks like a match has already been found."
      @error = true
    elsif @offer
      data = review_offer_params
      error = @offer.add_response(data)
      CreatorMatching.handle_post_response_matching(@offer) unless error
    else
      error = "This offer is no longer valid. Looks like a match has already been found."
      @error = true
    end

    flash.now[:alert] = error if error
    flash.now[:notice] = "Response received. Thank you!" unless error
    render :edit
  end

  # strong parameters for review offer
  private

    def review_offer_params
      params.require(:creator_review_offer)
        .permit(:option_one_response, :option_two_response,
                :option_three_response, :not_available_for_any_options,
                :does_not_want_to_review_this_restaurant,
                :does_not_want_to_review_reason, :notes)
            .to_h.deep_transform_keys!(&:underscore)
    end
end
