# frozen_string_literal: true
class LogEventPolicy < ApplicationPolicy
  attr_reader :user, :log_event

  def initialize(user, log_event)
    @user = user
    @log_event = log_event
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
