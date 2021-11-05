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
    flash[:alert] = @error
  end

  def update
    @offer = CreatorReviewOffer.find_by(id: params[:id])
    @data = review_offer_params
    # verify it has not been responded to already
    if @offer.responded_at
      error = "This offer has already been responded too"
    elsif no_option_selected?
      # an option must be selected
      error = "Please select an option: one or more date/time option(s), if you're not available or if you do not want to review this restaurant"
    elsif selected_option_and_no_option_reason?
      error = "Hmm...looks like you selected a datetime option and selected a can't make it option. Please select one or the other"
    elsif no_reason_given?
      # a reason must be given if they select do not want to review
      error = "Please give a reason as to why you do not want to review this restaurant. This will help us find better restaurants for you in the future!"
    end
    @data[:responded_at] = Time.now
    @offer.assign_attributes(@data)
    unless error
      begin
        @offer.save!
      rescue Exception => e
        Airbrake.notify("Creator review offer could not be responded to", {
          error: e,
          errors: @offer.errors.full_messages,
          params: params,
          offer_id: @offer.id,
          restaurant_name: @offer.restaurant.name
        })
        error = "Oops! something went wrong. We have been notified and will fix the issue soon!"
      end
    end

    # check for match
    #
    # if match, update final scheduled time
    # send confirmation emails to restaurant and creators
    # create and send google events
    #
    # if no match
    # send out to everyone
    # first response gets it
    flash.now[:alert] = error if error
    flash.now[:notice] = "Response received. Thank you!" unless error
    render :edit
  end

  # strong parameters for review offer
  private

    def selected_option_and_no_option_reason?
      return (@data[:option_one_response] == "1" ||
        @data[:option_two_response] == "1" ||
        @data[:option_three_response] == "1") &&
        (@data[:not_available_for_any_options] == "1" ||
        @data[:does_not_want_to_review_this_restaurant] == "1")
    end

    def no_reason_given?
      return @data[:does_not_want_to_review_this_restaurant] == "1" &&
        @data[:does_not_want_to_review_reason].blank?
    end

    def no_option_selected?
      return @data[:option_one_response] != "1" &&
        @data[:option_two_response] != "1" &&
        @data[:option_three_response] != "1" &&
        @data[:not_available_for_any_options] != "1" &&
        @data[:does_not_want_to_review_this_restaurant] != "1"
    end

    def review_offer_params
      params.require(:creator_review_offer)
        .permit(:option_one_response, :option_two_response,
                :option_three_response, :not_available_for_any_options,
                :does_not_want_to_review_this_restaurant,
                :does_not_want_to_review_reason, :notes)
            .to_h.deep_transform_keys!(&:underscore)
    end
end
