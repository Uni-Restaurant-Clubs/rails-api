class CurrentUserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :email, :subscription_active

  def subscription_active
    StripePayments.user_has_active_subscription(object)
  end
end
