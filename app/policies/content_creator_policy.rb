# frozen_string_literal: true
class ContentCreatorPolicy < ApplicationPolicy
  attr_reader :user, :content_creator

  def initialize(user, content_creator)
    @user = user
    @content_creator = content_creator
  end

  def index?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.creators_admin?
    false
  end

  def show?
    return true if @user.super_admin?
    return true if @user.restaurant_reviews_admin?
    return true if @user.creators_admin?
    false
  end

  def new?
    return true if @user.super_admin?
    return true if @user.creators_admin?
    false
  end

  def create?
    return true if @user.super_admin?
    return true if @user.creators_admin?
    false
  end

  def edit?
    return true if @user.super_admin?
    return true if @user.creators_admin?
    false
  end

  def update?
    return true if @user.super_admin?
    return true if @user.creators_admin?
    false
  end

  def destroy?
    return true if @user.super_admin?
    false
  end

end
