# frozen_string_literal: true
class RestaurantPolicy < ApplicationPolicy
  attr_reader :user, :restaurant

  def initialize(user, restaurant)
    @user = user
    @restaurant = restaurant
  end

  def index?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.restaurant_promotions_admin?
    false
  end

  def show?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.restaurant_promotions_admin?
    return true if @user.creators_admin?
    false
  end

  def new?
    return true if @user.super_admin?
    false
  end

  def create?
    return true if @user.super_admin?
    false
  end

  def edit?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.restaurant_promotions_admin?
    return true if @user.creators_admin?
    false
  end

  def update?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.restaurant_promotions_admin?
    return true if @user.creators_admin?
    false
  end

  def destroy?
    return true if @user.super_admin?
    false
  end

end
