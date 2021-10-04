class Api::V1::ReviewHappenedConfirmationsController < Api::V1::ApiApplicationController

  def respond
    binding.pry
    token = params[:token]
    response = params[:response]
    #validate token and response
    #
    # if reviewed
    # set status to reviewed
    # send out restaurant and creators post reviewed emails
    #
    # if wasn't reviewed
    # need to update status to not reviewed needs rescheduling
    # send email to admins
  end

end
