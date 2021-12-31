class CheckInSerializer < ActiveModel::Serializer
  attributes :id, :feature_period_id, :restaurant_id, :user_is_at_restaurant

end
