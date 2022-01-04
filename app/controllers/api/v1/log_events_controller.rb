class Api::V1::LogEventsController < Api::V1::ApiApplicationController
  before_action :check_for_api_user, only: [:track]

  def track
    data = event_params
    data[:user_id] = @current_user&.id
    data[:user_ip_address] = request.remote_ip
    if username = data[:public_unique_username]
      creator = ContentCreator.find_by(public_unique_username: username)
      data[:creator_id] = creator.id
      data.delete(:public_unique_username)
    end
    Analytics.track(data[:event_name], data)
    render json: {}, status: 204
  end

  private

    def event_params
      params.require(:event)
        .permit(:event_name, :creator_id, :user_id, :restaurant_id, :label, :category,
                :public_unique_username, :properties, :feature_period_id)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
