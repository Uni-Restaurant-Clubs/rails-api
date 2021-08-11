class Image < ApplicationRecord
  belongs_to :review, optional: true
  belongs_to :writer, optional: true
  belongs_to :photographer, optional: true

  # cheat sheet for resizing
  # https://dev.to/mikerogers0/resize-images-with-active-storage-in-rails-481n
  has_one_attached :photo

  scope :featured, -> {
    where(featured: true)
  }

  enum image_type: { "profile" => 0, "review" => 1}

  def resize_to_fit(size)
    self.photo.variant(resize_to_fit: [1000, 1000], format: :jpg)
  end

end
