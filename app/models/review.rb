class Review < ApplicationRecord
  belongs_to :restaurant
  has_many :images, as: :imageable
end
