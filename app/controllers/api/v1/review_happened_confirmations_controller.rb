class Api::V1::ReviewHappenedConfirmationsController < Api::V1::ApiApplicationController

  def respond
    token = params[:id]
    response = params[:response]
    confirmation = ReviewHappenedConfirmation.find_by(token: token)
    error = false

    if !token || !response
      error = "missing token or response"
    elsif !confirmation
      error = "confirmation not found"
    elsif confirmation.responded_at
      error = "Confirmation already responded to"
    elsif confirmation.created_at < Time.now - 7.days
      error = "Confirmation is too old"
    end

    if error
      Airbrake.notify("Cannot update ReviewHappenedConfirmation", {
        error: error,
        token: token,
        response: response,
        confirmation_id: confirmation&.id
      })
      return render html: error
    end

    result = confirmation.update_response_and_handle_next_steps(response)
    render html: result[:message]
  end

end
