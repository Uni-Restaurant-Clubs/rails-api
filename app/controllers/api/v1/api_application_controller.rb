class Api::V1::ApiApplicationController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def authenticate_api_user!
    # TODO get from header
    token = params[:token]
    session = Session.find_by(token: token)

    if session && session.user
      if Time.now > (session.created_at + 1.month)
        session.destroy
        json = { error: true,
                 message: "Session has expired. User must login again" }.to_json
        render json: json, status: 401 and return
      else
        session.update(last_used: Time.now)
        @current_user = session.user
      end
    else
      message = "Access token is missing or invalid"
      json = { error: true, message: message }.to_json
      # TODO get status for unauthorized
      render json: json, status: 401 and return
    end
  end

  def current_api_user

  end

end
