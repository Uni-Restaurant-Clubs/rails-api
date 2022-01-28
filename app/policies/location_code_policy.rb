# frozen_string_literal: true
class LocationCodePolicy < ApplicationPolicy
  attr_reader :user, :location_code

  def initialize(user, location_code)
    @user = user
    @location_code = location_code
  end

  def index?
    return true if @user.super_admin?
    false
  end

  def show?
    return true if @user.super_admin?
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
