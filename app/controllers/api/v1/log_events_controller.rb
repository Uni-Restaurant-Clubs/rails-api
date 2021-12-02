class Api::V1::LogEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def track
    data = event_params
    Analytics.track(data[:event_name], data)
  end

  def page_view
    data = event_params
    Analytics.page_view(data[:label], data)
  end

  private

    def event_params
      params.require(:event)
        .permit(:event_name, :user_id, :restaurant_id, :label, :category,
                :properties)
            .to_h.deep_transform_keys!(&:underscore)
    end

end
