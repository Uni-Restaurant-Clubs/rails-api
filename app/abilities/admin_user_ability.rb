# frozen_string_literal: true

module AdminUserAbility

  def admin_user_ability(user)
    can :manage, :all

    return unless user.restaurant_reviews_admin?
    can :manage, :all
  end
end

