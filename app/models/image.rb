class Image < ApplicationRecord
  belongs_to :photographer
  belongs_to :review
  belongs_to :restaurant
  has_one_attached :photo
end
