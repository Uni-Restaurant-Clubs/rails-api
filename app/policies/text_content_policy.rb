# frozen_string_literal: true
class TextContentPolicy < ApplicationPolicy
  attr_reader :user, :text_content

  def initialize(user, text_content)
    @user = user
    @text_content = text_content
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
