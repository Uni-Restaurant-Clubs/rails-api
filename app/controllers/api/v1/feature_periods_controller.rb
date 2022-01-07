class Api::V1::FeaturePeriodsController < Api::V1::ApiApplicationController
  before_action :authenticate_api_user!, only: [:show]
  before_action :check_subscription!, only: [:show]

  def show
    if StripePayments.user_has_active_subscription(@current_user)
      feature_period = FeaturePeriod.find_by(id: params[:id])
      if !feature_period
        Airbrake.notify("Deal could not be found", {
          feature_period_id: feature_period.id,
          current_user_email: @current_user&.email
        })
        json = { error: true, message: "Deal does not exist" }.to_json
        render json: json, status: 404
      else
        render json: feature_period, status: 200, serializer: FeaturePeriodSerializer
      end
    else

    end

  end

end

