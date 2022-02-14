# frozen_string_literal: true
class PromotionInfoPolicy < ApplicationPolicy
  attr_reader :user, :promotion_info

  def initialize(user, promotion_info)
    @user = user
    @promotion_info = promotion_info
  end

  def index?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def show?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def new?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def create?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def edit?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def update?
    return true if @user.super_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def destroy?
    return true if @user.super_admin?
    false
  end

end
