# frozen_string_literal: true
class AdminUserPolicy < ApplicationPolicy
  attr_reader :user, :admin_user

  def initialize(user, admin_user)
    @user = user
    @admin_user = admin_user
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
