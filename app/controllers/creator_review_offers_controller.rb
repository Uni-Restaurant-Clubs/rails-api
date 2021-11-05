class CreatorReviewOffersController < ApplicationController

  def edit
    @token = params[:id]
    @offer = CreatorReviewOffer.find_by(token: @token)
    if !@offer
      @error = "Offer could not be found"
    elsif @offer.responded_at
      # verify it has not been responded to already
      @error = "This offer has already been responded to"
    elsif Time.now > @offer.created_at + 2.days
      # validate date (can't be more than 2 days old)
      @error = "This offer has expired since it was sent more than 2 days ago."
    end
  end

  def update
    binding.pry
    # verify it has not been responded to already
    # update offer
    # update responded at
    # check for match
    #
    # if match, update final scheduled time
    # send confirmation emails to restaurant and creators
    # create and send google events
    #
    # if no match
    # send out to everyone
    # first response gets it
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
