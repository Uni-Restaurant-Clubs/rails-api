class Review < ApplicationRecord
  belongs_to :restaurant
  belongs_to :university, optional: true
  belongs_to :writer, class_name: 'ContentCreator', foreign_key: 'writer_id'
  belongs_to :photographer, class_name: 'ContentCreator', foreign_key: 'photographer_id'
  has_many :images

  validates_presence_of :restaurant_id, :writer_id, :photographer_id

  accepts_nested_attributes_for :images, :allow_destroy => true

  enum status: { "not public" => 0, "open to public" => 1 }

  default_scope { where(status: 1) }
  scope :newest_first, lambda { order("created_at ASC") }

  def limit_words
    #full_article.split("<p>").first.split
  end

  def featured_photo
    self.images.featured.first
  end
end
