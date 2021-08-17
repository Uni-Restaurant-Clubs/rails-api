class Review < ApplicationRecord
  belongs_to :restaurant
  belongs_to :university
  belongs_to :writer
  belongs_to :photographer
  has_many :images

  validates_presence_of :restaurant_id, :university_id, :writer_id,
                        :photographer_id

  accepts_nested_attributes_for :images, :allow_destroy => true

  def limit_words
    #full_article.split("<p>").first.split
  end

  def featured_photo
    self.images.featured.first
  end
end
