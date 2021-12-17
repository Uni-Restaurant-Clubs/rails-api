class CheckIn < ApplicationRecord
  belongs_to :restaurant, optional: true
  belongs_to :feature_period, optional: true
  belongs_to :user
end
