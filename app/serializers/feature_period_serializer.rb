class FeaturePeriodSerializer < ActiveModel::Serializer

  attributes :id, :disclaimers, :perks, :deal, :review

  belongs_to :restaurant

  def review
    review = object.restaurant.reviews.last
    ReviewSerializer.new(review) if review
  end

  def deal
    object.readable_deal
  end

  class RestaurantSerializer < ActiveModel::Serializer
    attributes :name, :id
  end

  class ReviewSerializer < ActiveModel::Serializer
    attributes :article_title, :id, :featured_photo

    def featured_photo
      photo = object.featured_photo
      if photo
        {
          id: photo.id,
          name: photo.title,
          photo: photo.resize_to_fit(400).try(:processed).try(:url)
        }
      else
        { name: "", photo: "" }
      end
    end
  end
end
