# frozen_string_literal: true
class RolePolicy < ApplicationPolicy
  attr_reader :user, :role

  def initialize(user, role)
    @user = user
    @role = role
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
