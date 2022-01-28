# frozen_string_literal: true
module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    def show?
      return true if @user.super_admin?
      case record.name
      when "Dashboard"
        true
      when "Accepted Unscheduled Reviews"
        return true if @user.restaurant_reviews_admin?
        return true if @user.creators_admin?
      when "Scheduled Reviews"
        return true if @user.restaurant_reviews_admin?
        return true if @user.creators_admin?
      when "Completed Reviews"
        return true if @user.restaurant_reviews_admin?
        return true if @user.restaurant_promotions_admin?
        return true if @user.creators_admin?
      else
        false
      end
    end
  end
end
