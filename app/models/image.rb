class Image < ApplicationRecord
  belongs_to :review
  # cheat sheet for resizing
  # https://dev.to/mikerogers0/resize-images-with-active-storage-in-rails-481n
  has_one_attached :photo do |attachable|
    attachable.variant :medium, resize: "250x250"
    attachable.variant :large, resize: "500x500"
  end

  scope :featured, -> {
    where(featured: true)
  }

  def thumb
    self.photo.variant(resize_to_fit: [200,200], format: :jpg)
  end

  def medium
    self.photo.variant(resize_to_fit: [250,250], format: :jpg)
  end

  def large
    self.photo.variant(resize_to_fit: [700,700], format: :jpg)
  end

end
