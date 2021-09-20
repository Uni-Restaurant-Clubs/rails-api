class RestaurantCategoryRestaurant < ApplicationRecord

  belongs_to :restaurant
  belongs_to :restaurant_category
end
