class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :reviewed_at, :article, :photos

  belongs_to :writer
  belongs_to :photographer
  belongs_to :restaurant
  belongs_to :university

  def photos
    object.images.map do |image|
      {
        name: image.title,
        photo: image.resize_to_fit(500).try(:processed).try(:url)
      }
    end
  end

  def article
    object.full_article
  end

  class WriterSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :photo

    def photo
      if object.image
        object.image.resize_to_fit(500).try(:processed).try(:url)
      end
    end

  end

  class PhotographerSerializer < ActiveModel::Serializer
    attributes :first_name, :last_name, :photo

    def photo
      if object.image
        object.image.resize_to_fit(500).try(:processed).try(:url)
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
