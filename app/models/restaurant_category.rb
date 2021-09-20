class RestaurantCategory < ApplicationRecord
  has_many :restaurant_category_restaurants, dependent: :destroy
  has_many :restaurants, through: :restaurant_category_restaurants

end
