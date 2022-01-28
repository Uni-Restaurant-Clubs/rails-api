# frozen_string_literal: true
class FeaturePeriodPolicy < ApplicationPolicy
  attr_reader :user, :feature_period

  def initialize(user, feature_period)
    @user = user
    @feature_period
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
