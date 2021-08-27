class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :reviewed_at, :article, :photos, :article_title,
             :featured_photo

  belongs_to :writer
  belongs_to :photographer
  belongs_to :restaurant
  belongs_to :university

  def article_title
    object.article_title&.capitalize
  end

  def photos
    object.images.map do |image|
      {
        name: image.title,
        photo: image.resize_to_fit(1000).try(:processed).try(:url)
      }
    end
  end

  def featured_photo
    photo = object.featured_photo
    if photo
      {
        name: photo.title,
        photo: photo.resize_to_fit(1000).try(:processed).try(:url)
      }
    else
      { name: "", photo: "" }
    end
  end

  def article
    object.full_article
  end

  class ContentCreatorSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :photo, :public_unique_username

    def photo
      if object.image
        object.image.resize_to_fit(1000).try(:processed).try(:url)
      end
    end

  end

  class UniversitySerializer < ActiveModel::Serializer
    attributes :name
  end

  class RestaurantSerializer < ActiveModel::Serializer
    attributes :name
  end

end
