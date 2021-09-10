class Api::V1::ApiApplicationController < ApplicationController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token

  def authenticate_api_user!
    token = request.headers['Authorization'].split(' ').last rescue nil
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
      render json: json, status: 401 and return
    end
  end

  def check_for_api_user
    token = request.headers['Authorization'].split(' ').last rescue nil
    session = Session.find_by(token: token)

    if session && session.user
      unless Time.now > (session.created_at + 1.month)
        session.update(last_used: Time.now)
        @current_user = session.user
      end
    end
  end

end
