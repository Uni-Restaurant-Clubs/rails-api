# frozen_string_literal: true
class CheckInPolicy < ApplicationPolicy
  attr_reader :user, :check_in

  def initialize(user, check_in)
    @user = user
    @check_in = check_in
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
    false
  end

  def create?
    return true if @user.super_admin?
    false
  end

  def edit?
    return true if @user.super_admin?
    false
  end

  def update?
    return true if @user.super_admin?
    false
  end

  def destroy?
    return true if @user.super_admin?
    false
  end

end
